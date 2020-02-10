package com.acn.dlt.corda.doorman.storage.mongo

import de.flapdoodle.embed.mongo.Command
import de.flapdoodle.embed.mongo.MongoShellStarter
import de.flapdoodle.embed.mongo.MongodExecutable
import de.flapdoodle.embed.mongo.MongodStarter
import de.flapdoodle.embed.mongo.config.*
import de.flapdoodle.embed.mongo.distribution.Feature
import de.flapdoodle.embed.mongo.distribution.IFeatureAwareVersion
import de.flapdoodle.embed.process.config.io.ProcessOutput
import de.flapdoodle.embed.process.distribution.BitSize
import de.flapdoodle.embed.process.distribution.Distribution
import de.flapdoodle.embed.process.distribution.Platform
import de.flapdoodle.embed.process.extract.ImmutableExtractedFileSet
import de.flapdoodle.embed.process.io.*
import de.flapdoodle.embed.process.io.Processors.console
import de.flapdoodle.embed.process.io.Processors.namedConsole
import de.flapdoodle.embed.process.runtime.Network
import de.flapdoodle.embed.process.store.StaticArtifactStore
import io.bluebank.braid.core.logging.loggerFor
import org.slf4j.LoggerFactory
import java.io.*
import java.util.*
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit


internal class EmbeddedMongo private constructor(
  dbDirectory: String,
  private val mongodLocation: String, // empty string if none available
  private val enableAuth: Boolean,
  private val isDaemonProcess: Boolean = true
) : Closeable {
  companion object {
    const val INIT_TIMEOUT_MS = 30000L
    const val USER_ADDED_TOKEN = "Successfully added user"
    const val MONGO_USER = "mongo"
    const val MONGO_PASSWORD = "mongo"
    private val logger = loggerFor<EmbeddedMongo>()
    fun create(dbDirectory: String, mongodLocation: String, isDaemonProcess: Boolean = true): EmbeddedMongo {
      logger.info("starting up mongod to prepare auth. dbDirectory: $dbDirectory isDaemon: false")
      EmbeddedMongo(dbDirectory, mongodLocation, false, false).apply {
        addAdmin()
        // implicit shutdown happens because we have updated the authentication mechanism
      }
      logger.info("starting up mongod second time with auth. dbDirectory: $dbDirectory isDaemon: $isDaemonProcess")
      return EmbeddedMongo(dbDirectory, mongodLocation, true, isDaemonProcess)
        .also {
          logger.info("mongo database started on ${it.connectionString} mounted on ${it.location.absolutePath}")
        }
    }
  }

  //  private val RequiredVersion = PRODUCTION
  private object RequiredVersion : IFeatureAwareVersion {
    private val features = EnumSet.of(Feature.SYNC_DELAY, Feature.STORAGE_ENGINE, Feature.ONLY_64BIT, Feature.NO_CHUNKSIZE_ARG, Feature.MONGOS_CONFIGDB_SET_STYLE, Feature.NO_HTTP_INTERFACE_ARG, Feature.ONLY_WITH_SSL, Feature.ONLY_WINDOWS_2008_SERVER, Feature.NO_SOLARIS_SUPPORT, Feature.NO_BIND_IP_TO_LOCALHOST)
    override fun getFeatures(): EnumSet<Feature> = features
    override fun asInDownloadPath() = "4.0.4"
    override fun enabled(feature: Feature?) = features.contains(feature)
  }

  private val bindIP = "localhost"
  private val port = Network.getFreeServerPort()
  private val location = File(dbDirectory).also { it.mkdirs() }
  private val replication = Storage(location.absolutePath, null, 0)
  private val executable: MongodExecutable
  val connectionString
    get() = when (enableAuth) {
      true -> "mongodb://$MONGO_USER:$MONGO_PASSWORD@$bindIP:$port"
      false -> "mongodb://$bindIP:$port"
    }

  private val mongodConfig = MongodConfigBuilder()
    .version(RequiredVersion)
    .net(Net(bindIP, port, Network.localhostIsIPv6()))
    .replication(replication)
    .cmdOptions(MongoCmdOptionsBuilder()
      .enableAuth(enableAuth)
      .syncDelay(10)
      .useNoPrealloc(false)
      .useSmallFiles(false)
      .useNoJournal(false)
      .enableTextSearch(true)
      .build())
    .build()

  init {
    val mongoLogger = LoggerFactory.getLogger("mongo")
    val processOutput = ProcessOutput(Processors.logTo(mongoLogger, Slf4jLevel.INFO), Processors.logTo(mongoLogger, Slf4jLevel.ERROR), Processors.logTo(mongoLogger, Slf4jLevel.INFO))

    val runtimeConfig = RuntimeConfigBuilder().defaults(Command.MongoD).processOutput(processOutput)
      .apply {
        if (mongodLocation.isNotBlank()) {
          val execFile = File(mongodLocation).absoluteFile
          if (!execFile.exists()) {
            throw FileNotFoundException("could not locate mongod executable $mongodLocation")
          }
          val fileSet = ImmutableExtractedFileSet.builder(execFile.parentFile).baseDirIsGenerated(false).executable(execFile).build()
          val distribution = Distribution(RequiredVersion, Platform.detect(), BitSize.detect())
          val store = StaticArtifactStore(mutableMapOf(distribution to fileSet))
          artifactStore(store)
        }
      }
      .daemonProcess(isDaemonProcess)
      .build()
    val starter = MongodStarter.getInstance(runtimeConfig)
    executable = starter.prepare(mongodConfig)
    executable.start()
  }

  override fun close() {
    when (isDaemonProcess) {
      true -> logger.info("request for shutdown ignored: process is daemon and will shutdown during JVM shutdown")
      else -> {
        logger.info("manual shutdown in progress")
        val countDownLatch = CountDownLatch(1)
        val timeout = 5L // seconds
        val shutdownThread = object : Thread() {
          override fun run() {
            executable.stop()
            countDownLatch.countDown()
          }
        }
        shutdownThread.start()
        try {
          countDownLatch.await(timeout, TimeUnit.SECONDS)
        } catch (err: Throwable) {
          logger.error("failed to shutdown mongo within $timeout seconds", err)
        }
      }
    }
  }

  @Throws(IOException::class)
  private fun runScriptAndWait(scriptText: String, token: String, failures: Array<String>?, dbName: String, username: String?, password: String?) {
    val mongoLogger = LoggerFactory.getLogger("mongo")
    val mongoOutput: IStreamProcessor = if (token.isNotEmpty()) {
      LogWatchStreamProcessor(
        String.format(token),
        if (failures != null) HashSet(failures.toList()) else emptySet(),
        Processors.logTo(mongoLogger, Slf4jLevel.INFO))
    } else {
      NamedOutputStreamProcessor("[mongo shell output]", console())
    }
    val runtimeConfig = RuntimeConfigBuilder()
      .defaults(Command.Mongo)
      .daemonProcess(false)
      .processOutput(ProcessOutput(
        mongoOutput,
        namedConsole("[mongo shell error]"),
        console()))
      .build()

    val scriptFile = writeTmpScriptFile(scriptText)
    val builder = MongoShellConfigBuilder()
    if (dbName.isNotEmpty()) {
      builder.dbName(dbName)
    }
    if (username != null && username.isNotEmpty()) {
      builder.username(username)
    }
    if (password != null && password.isNotEmpty()) {
      builder.password(password)
    }
    val mongoShellConfig = builder
      .scriptName(scriptFile.absolutePath)
      .version(mongodConfig.version())
      .net(mongodConfig.net())
      .build()

    val starter = MongoShellStarter.getInstance(runtimeConfig)
    val shell = starter.prepare(mongoShellConfig).start()
    try {
      if (mongoOutput is LogWatchStreamProcessor) {
        mongoOutput.waitForResult(INIT_TIMEOUT_MS)
      }
    } finally {
      shell.stop()
    }
  }

  @Throws(IOException::class)
  private fun writeTmpScriptFile(scriptText: String): File {
    val scriptFile = File.createTempFile("tempfile", ".js")
    scriptFile.deleteOnExit()
    val bw = BufferedWriter(FileWriter(scriptFile))
    bw.write(scriptText)
    bw.close()
    return scriptFile
  }

  @Throws(IOException::class)
  private fun addAdmin() {
    val script = """
      db.createUser({
        "user": "$MONGO_USER",
        "pwd": "$MONGO_PASSWORD",
        "roles": [ { "role": "userAdminAnyDatabase", "db": "admin" }, "readWriteAnyDatabase" ]
      })
    """.trimIndent()
    runScriptAndWait(script, USER_ADDED_TOKEN, arrayOf("couldn't add user", "failed to load", "login failed"), "admin", null, null)
  }
}

