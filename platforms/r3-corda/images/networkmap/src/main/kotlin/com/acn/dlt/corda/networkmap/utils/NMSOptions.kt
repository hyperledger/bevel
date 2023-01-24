package com.acn.dlt.corda.networkmap.utils

import com.acn.dlt.corda.networkmap.service.*
import com.acn.dlt.corda.networkmap.storage.mongo.MongoStorage
import io.vertx.ext.auth.AuthProvider
import io.vertx.ext.auth.User
import net.corda.core.identity.CordaX500Name
import net.corda.nodeapi.internal.DEV_ROOT_CA
import net.corda.nodeapi.internal.crypto.CertificateAndKeyPair
import java.io.File
import java.time.Duration

class NMSOptions(val port: Int = 8080,
                 val dbDirectory: File = File(".db"),
                 val cacheTimeout: Duration = Duration.ofSeconds(2),
                 val paramUpdateDelay: Duration = Duration.ofSeconds(10),
                 val networkMapUpdateDelay: Duration = Duration.ofSeconds(1),
                 val tls: Boolean = false,
                 val certPath: String = "",
                 val keyPath: String = "",
                 val hostname: String = "0.0.0.0",
                 val user: User = InMemoryUser("System Admin", "sa", "admin"),
                 val enableDoorman: Boolean = true,
                 val enableCertman: Boolean = true,
                 val pkix: Boolean = false,
                 val truststore: File? = null,
                 val trustStorePassword: String? = null,
                 val strictEV: Boolean = false,
                 val webRoot: String = "/",
                 val storageType: StorageType = StorageType.MONGO,
                 val mongoConnectionString: String = "embed",
                 val mongodLocation: String = "",
                 val mongodDatabase: String = MongoStorage.DEFAULT_DATABASE,
                 val rootCA : CertificateAndKeyPair = CertificateManager.createSelfSignedCertificateAndKeyPair(CertificateManagerConfig.DEFAULT_ROOT_NAME),
                 val networkParametersPath: String = "",
                 val rootCAFilePath: String = "",
                 val allowNodeKeyChange: Boolean = false) : Options() {
  val authProvider : AuthProvider by lazy {
     when (user) {
       is InMemoryUser -> InMemoryAuthProvider(user)
       else -> error("unhandled ")
     }
  }

  companion object {
    fun parse(): NMSOptions {
      return parse(NMSOptionsParser())
    }

    fun parse(nmsOptionsParser: NMSOptionsParser): NMSOptions {
      return NMSOptions(
        port = nmsOptionsParser.portOpt.intValue,
        dbDirectory = nmsOptionsParser.dbDirectoryOpt.stringValue.toFile(),
        cacheTimeout = Duration.parse("PT${nmsOptionsParser.cacheTimeoutOpt.stringValue}"),
        paramUpdateDelay = Duration.parse("PT${nmsOptionsParser.paramUpdateDelayOpt.stringValue}"),
        networkMapUpdateDelay = Duration.parse("PT${nmsOptionsParser.networkMapUpdateDelayOpt.stringValue}"),
        tls = nmsOptionsParser.tlsOpt.booleanValue,
        certPath = nmsOptionsParser.certPathOpt.stringValue,
        keyPath = nmsOptionsParser.keyPathOpt.stringValue,
        hostname = nmsOptionsParser.hostNameOpt.stringValue,
        user = InMemoryUser.createUser("System Admin", nmsOptionsParser.usernameOpt.stringValue, nmsOptionsParser.passwordOpt.stringValue),
        enableDoorman = nmsOptionsParser.doormanOpt.booleanValue,
        enableCertman = nmsOptionsParser.certmanOpt.booleanValue,
        pkix = nmsOptionsParser.certManpkixOpt.booleanValue,
        truststore = if (nmsOptionsParser.certmanTruststoreOpt.stringValue.isNotEmpty()) File(nmsOptionsParser.certmanTruststoreOpt.stringValue) else null,
        trustStorePassword = if (nmsOptionsParser.certmanTruststorePasswordOpt.stringValue.isNotEmpty()) nmsOptionsParser.certmanTruststorePasswordOpt.stringValue else null,
        strictEV = nmsOptionsParser.certmanStrictEV.booleanValue,
        webRoot = nmsOptionsParser.webRootOpt.stringValue,
        mongoConnectionString = nmsOptionsParser.mongoConnectionOpt.stringValue,
        mongodLocation = nmsOptionsParser.mongodLocationOpt.stringValue,
        mongodDatabase = nmsOptionsParser.mongodDatabaseOpt.stringValue,
        storageType = StorageType.valueOf(nmsOptionsParser.storageType.stringValue.toUpperCase()),
        rootCA = if (!nmsOptionsParser.doormanOpt.booleanValue && !nmsOptionsParser.certmanOpt.booleanValue) {
          DEV_ROOT_CA
        } else {
          CertificateManager.createSelfSignedCertificateAndKeyPair(CordaX500Name.parse(nmsOptionsParser.rootX509Name.stringValue))
        },
        networkParametersPath = nmsOptionsParser.networkParametersPath.stringValue,
        rootCAFilePath = nmsOptionsParser.rootCAFilePath.stringValue,
        allowNodeKeyChange = nmsOptionsParser.allowNodeKeyChange.booleanValue
      )
    }
  }
}

class NMSOptionsParser : Options() {
  val portOpt = addOption("port", "8080", "web port")
  val dbDirectoryOpt = addOption("db", ".db", "database directory for this service")
  val cacheTimeoutOpt = addOption("cache-timeout", "2S", "http cache timeout for this service in ISO 8601 duration format")
  val paramUpdateDelayOpt = addOption("param-update-delay", "10S", "schedule duration for a parameter update")
  val networkMapUpdateDelayOpt = addOption("network-map-delay", "1S", "queue time for the network map to update for addition of nodes")
  val usernameOpt = addOption("auth-username", "sa", "system admin username")
  val passwordOpt = addOption("auth-password", "admin", "system admin password")
  val tlsOpt = addOption("tls", "false", "whether TLS is enabled or not")
  val certPathOpt = addOption("tls-cert-path", "", "path to cert if TLS is turned on")
  val keyPathOpt = addOption("tls-key-path", "", "path to key if TLS turned on")
  val hostNameOpt = addOption("hostname", "0.0.0.0", "interface to bind the service to")
  val doormanOpt = addOption("doorman", "true", "enable Corda doorman protocol")
  val certmanOpt = addOption("certman", "true", "enable Corda certman protocol so that nodes can authenticate using a signed TLS cert")
  val certManpkixOpt = addOption("certman-pkix", "false", "enables certman's pkix validation against JDK default truststore")
  val certmanTruststoreOpt = addOption("certman-truststore", "", "specified a custom truststore instead of the default JRE cacerts")
  val certmanTruststorePasswordOpt = addOption("certman-truststore-password", "", "truststore password")
  val certmanStrictEV = addOption("certman-strict-ev", "false", "enables strict constraint for EV certs only in certman")
  val rootX509Name = addOption("root-ca-name", "CN=\"<replace me>\", OU=DLT, O=DLT, L=London, ST=London, C=GB", "the name for the root ca. If doorman and certman are turned off this will automatically default to Corda dev root ca")
  val webRootOpt = addOption("web-root", "/", "for remapping the root url for all requests")
  val mongoConnectionOpt = addOption("mongo-connection-string", "embed", "MongoDB connection string. If set to `embed` will start its own mongo instance")
  val mongodLocationOpt = addOption("mongod-location", "", "optional location of pre-existing mongod server")
  val mongodDatabaseOpt = addOption("mongod-database", MongoStorage.DEFAULT_DATABASE, "name for mongo database")
  val storageType = addOption("storage-type", StorageType.FILE.name.toLowerCase(), "file | mongo")
  val networkParametersPath =  addOption("nmp-path", "", "path to network map parameters file")
  val rootCAFilePath = addOption("root-ca-file-path", "", "path to root cert file")
  val allowNodeKeyChange =  addOption("allow-node-key-change", "false", "to allow registration of a node with same legal name but different legal identity with NMS")
}