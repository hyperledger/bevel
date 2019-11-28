@file:Suppress("DEPRECATION")

package com.acn.dlt.corda.networkmap.service

import com.mongodb.reactivestreams.client.MongoClient
import io.bluebank.braid.corda.BraidConfig
import io.bluebank.braid.corda.rest.AuthSchema
import io.bluebank.braid.corda.rest.RestConfig
import io.bluebank.braid.core.http.HttpServerConfig
import com.acn.dlt.corda.networkmap.serialisation.SerializationEnvironment
import com.acn.dlt.corda.networkmap.serialisation.deserializeOnContext
import com.acn.dlt.corda.networkmap.serialisation.serializeOnContext
import com.acn.dlt.corda.networkmap.utils.*
import io.netty.handler.codec.http.HttpHeaderValues
import io.netty.handler.codec.http.HttpResponseStatus
import io.swagger.annotations.ApiOperation
import io.swagger.models.Contact
import io.vertx.core.Future
import io.vertx.core.Handler
import io.vertx.core.Vertx
import io.vertx.core.buffer.Buffer
import io.vertx.core.http.HttpServerOptions
import io.vertx.core.net.SelfSignedCertificate
import io.vertx.ext.web.RoutingContext
import io.vertx.ext.web.handler.StaticHandler
import net.corda.core.crypto.SecureHash
import net.corda.core.crypto.SignedData
import net.corda.core.identity.CordaX500Name
import net.corda.core.node.NotaryInfo
import net.corda.core.utilities.NetworkHostAndPort
import net.corda.core.utilities.loggerFor
import net.corda.nodeapi.internal.SignedNodeInfo
import java.io.File
import java.net.InetAddress
import java.security.PublicKey
import java.time.Duration
import javax.ws.rs.core.HttpHeaders
import javax.ws.rs.core.HttpHeaders.*
import javax.ws.rs.core.MediaType

class NetworkMapService(
  dbDirectory: File,
  user: InMemoryUser,
  private val port: Int,
  private val cacheTimeout: Duration,
  private val networkMapQueuedUpdateDelay: Duration,
  private val tls: Boolean = true,
  private val certPath: String = "",
  private val keyPath: String = "",
  private val vertx: Vertx = Vertx.vertx(),
  private val hostname: String = "localhost",
  webRoot: String = "/",
  private val certificateManagerConfig: CertificateManagerConfig = CertificateManagerConfig(
    root = CertificateManager.createSelfSignedCertificateAndKeyPair(CertificateManagerConfig.DEFAULT_ROOT_NAME),
    doorManEnabled = true),
  val mongoClient: MongoClient,
  val mongoDatabase: String,
  val paramUpdateDelay: Duration
) {
  companion object {
    internal const val NETWORK_MAP_ROOT = "/network-map"
    internal const val ADMIN_REST_ROOT = "/admin/api"
    private const val ADMIN_BRAID_ROOT = "/braid/api"
    private const val SWAGGER_ROOT = "/swagger"
    private val logger = loggerFor<NetworkMapService>()

    init {
      SerializationEnvironment.init()
    }
  }

  private val root = webRoot.dropLastWhile { it == '/' }

  private val adminBraidRoot: String = root + ADMIN_BRAID_ROOT
  private val swaggerRoot: String = root + SWAGGER_ROOT

  internal val storages = ServiceStorages(vertx, dbDirectory, mongoClient, mongoDatabase)
  private val adminService = AdminServiceImpl()
  internal lateinit var processor: NetworkMapServiceProcessor
  private val authService = AuthService(user)
  internal val certificateManager = CertificateManager(storages.certAndKeys, certificateManagerConfig)

  fun startup(): Future<Unit> {
    // N.B. Ordering is important here
    return storages.setupStorage()
      .compose { startCertManager() }
      .compose { startProcessor() }
      .compose { startupBraid() }
  }

  fun shutdown(): Future<Unit> {
    processor.stop()
    mongoClient.close()
    return Future.succeededFuture(Unit)
  }

  private fun startupBraid(): Future<Unit> {
    try {
      val thisService = this
      val staticHandler = StaticHandler.create("website/public").setCachingEnabled(false)
      val result = Future.future<Unit>()
      val templateEngine = ResourceMvelTemplateEngine(
        cachingEnabled = true,
        properties = mapOf("location" to root),
        rootPath = "website/public/"
      )
      BraidConfig()
        .withVertx(vertx)
        .withPort(port)
        .withAuthConstructor(authService::createAuthProvider)
        .withService("admin", adminService)
        .withRootPath(adminBraidRoot)
        .withHttpServerOptions(createHttpServerOptions())
        .withRestConfig(RestConfig("Network Map ")
          .withAuthSchema(AuthSchema.Token)
          .withSwaggerPath(swaggerRoot)
          .withApiPath("$root/") // a little different because we need to mount the network map on '/network-map'
          .withContact(Contact().url("https://www.company.com/").name("Company, Inc."))
          .withDescription("""|<h4><a href="/">Networkmap Service</a></h4>
            |<b>Please note:</b> The protected parts of this API require JWT authentication.
            |To activate, execute the <code>login</code> method.
            |Then copy the returned JWT token and insert it into the <i>Authorize</i> swagger dialog box as
            |<code>Bearer &lt;token&gt;</code>
          """.trimMargin().replace("\n", ""))
          .withPaths {
            group("network map") {
              unprotected {
                get(NETWORK_MAP_ROOT, thisService::serveNetworkMap)
                post("$NETWORK_MAP_ROOT/publish", thisService::postNodeInfo)
                post("$NETWORK_MAP_ROOT/ack-parameters", thisService::postAckNetworkParameters)
                get("$NETWORK_MAP_ROOT/node-info/:hash", thisService::getNodeInfo)
                get("$NETWORK_MAP_ROOT/network-parameters/:hash", thisService::getNetworkParameter)
                get("$NETWORK_MAP_ROOT/my-hostname", thisService::getMyHostname)
                get("$NETWORK_MAP_ROOT/truststore", thisService::getNetworkTrustStore)
              }
            }
            group("admin") {
              unprotected {
                post("$ADMIN_REST_ROOT/login", authService::login)
                get("$ADMIN_REST_ROOT/whitelist", processor::serveWhitelist)
                get("$ADMIN_REST_ROOT/notaries", processor::serveNotaries)
                get("$ADMIN_REST_ROOT/nodes", processor::serveNodes)
                get("$ADMIN_REST_ROOT/network-parameters", processor::getAllNetworkParameters)
                get("$ADMIN_REST_ROOT/network-parameters/current", processor::getCurrentNetworkParameters)
                get("$ADMIN_REST_ROOT/network-map", processor::getCurrentNetworkMap)
                router {
                  route("/").handler { context ->
                    if (context.request().path() == root) {
                      context.response().putHeader(HttpHeaders.LOCATION, "$root/").setStatusCode(HttpResponseStatus.MOVED_PERMANENTLY.code()).end()
                    } else {
                      context.next()
                    }
                  }
                  route("/*").handler { context ->
                    templateEngine.handler(context, root)
                  }
                  route("/*").handler { context ->
                    staticHandler.handle(context)
                  }
                }
              }
              protected {
                put("$ADMIN_REST_ROOT/whitelist", processor::appendWhitelist)
                post("$ADMIN_REST_ROOT/whitelist", processor::replaceWhitelist)
                delete("$ADMIN_REST_ROOT/whitelist", processor::clearWhitelist)
                delete("$ADMIN_REST_ROOT/notaries/validating", processor::deleteValidatingNotary)
                delete("$ADMIN_REST_ROOT/notaries/nonValidating", processor::deleteNonValidatingNotary)
                delete("$ADMIN_REST_ROOT/nodes/:nodeKey", processor::deleteNode)
                post("$ADMIN_REST_ROOT/notaries/validating", processor::postValidatingNotaryNodeInfo)
                post("$ADMIN_REST_ROOT/notaries/nonValidating", processor::postNonValidatingNotaryNodeInfo)
              }
            }
          }
        ).bootstrapBraid(serviceHub = StubAppServiceHub(), fn = Handler {
          if (it.succeeded()) {
            result.complete()
          } else {
            result.fail(it.cause())
          }
        })
      return result
    } catch (err: Throwable) {
      return Future.failedFuture(err)
    }
  }

  @Suppress("MemberVisibilityCanBePrivate")
  @ApiOperation(value = "Retrieve the current signed network map object. The entire object is signed with the network map certificate which is also attached.",
    produces = MediaType.APPLICATION_OCTET_STREAM, response = Buffer::class)
  fun serveNetworkMap(context: RoutingContext) {
    processor.createSignedNetworkMap()
      .onSuccess { snm ->
        context.response().apply {
          setCacheControl(cacheTimeout)
          putHeader(CONTENT_TYPE, HttpHeaderValues.APPLICATION_OCTET_STREAM)
          end(Buffer.buffer(snm.serializeOnContext().bytes))
        }
      }
      .catch {
        logger.error("failed to create signed network map")
        context.end(it)
      }
  }

  @Suppress("MemberVisibilityCanBePrivate")
  @ApiOperation(value = "For the node to upload its signed NodeInfo object to the network map",
    consumes = MediaType.APPLICATION_OCTET_STREAM
  )
  fun postNodeInfo(nodeInfo: Buffer): Future<Unit> {
    val signedNodeInfo = nodeInfo.bytes.deserializeOnContext<SignedNodeInfo>()
    if (!certificateManagerConfig.devMode) {
      // formally check that this node has been registered via our certs
      certificateManager.validateNodeInfoCertificates(signedNodeInfo.verified())
    }
    return processor.addNode(signedNodeInfo)
  }

  @Suppress("MemberVisibilityCanBePrivate")
  @ApiOperation(value = "For the node operator to acknowledge network map that new parameters were accepted for future update.")
  fun postAckNetworkParameters(signedSecureHash: Buffer): Future<Unit> {
    val signedParameterHash = signedSecureHash.bytes.deserializeOnContext<SignedData<SecureHash>>()
    val hash = signedParameterHash.verified()
    return storages.nodeInfo.get(hash.toString())
      .onSuccess {
        logger.info("received acknowledgement from node ${it.verified().legalIdentities}")
      }
      .catch {
        logger.warn("received acknowledgement from unknown node!")
      }
      .mapUnit()
  }

  @Suppress("MemberVisibilityCanBePrivate")
  @ApiOperation(value = "Retrieve a signed NodeInfo as specified in the network map object.",
    response = Buffer::class,
    produces = MediaType.APPLICATION_OCTET_STREAM
  )
  fun getNodeInfo(context: RoutingContext) {
    val hash = SecureHash.parse(context.request().getParam("hash"))
    storages.nodeInfo.get(hash.toString())
      .onSuccess { sni ->
        context.response().apply {
          setCacheControl(cacheTimeout)
          putHeader(CONTENT_TYPE, HttpHeaderValues.APPLICATION_OCTET_STREAM)
          end(Buffer.buffer(sni.serializeOnContext().bytes))
        }
      }
      .catch {
        logger.error("failed to retrieve node info for hash $hash")
        context.end(it)
      }
  }

  @Suppress("MemberVisibilityCanBePrivate")
  @ApiOperation(value = "Retrieve the signed network parameters. The entire object is signed with the network map certificate which is also attached.",
    response = Buffer::class,
    produces = MediaType.APPLICATION_OCTET_STREAM)
  fun getNetworkParameter(context: RoutingContext) {
    val hash = SecureHash.parse(context.request().getParam("hash"))
    storages.networkParameters.get(hash.toString())
      .onSuccess { snp ->
        context.response().apply {
          setCacheControl(cacheTimeout)
          putHeader(CONTENT_TYPE, HttpHeaderValues.APPLICATION_OCTET_STREAM)
          end(Buffer.buffer(snp.serializeOnContext().bytes))
        }
      }
      .catch {
        logger.error("failed to retrieve the signed network parameters for hash $hash", it)
        context.end(it)
      }
  }

  @Suppress("MemberVisibilityCanBePrivate")
  @ApiOperation(value = "Retrieve this network-map's truststore",
    response = Buffer::class,
    produces = MediaType.APPLICATION_OCTET_STREAM)
  fun getNetworkTrustStore(context: RoutingContext) {
    try {
      context.response().apply {
        putHeader(CONTENT_TYPE, HttpHeaderValues.APPLICATION_OCTET_STREAM)
        putHeader(CONTENT_DISPOSITION, "attachment; filename=\"network-root-truststore.jks\"")
        end(Buffer.buffer(certificateManager.generateTrustStoreByteArray()))
      }
    } catch (err: Throwable) {
      context.end(err)
    }
  }

  @Suppress("MemberVisibilityCanBePrivate")
  @ApiOperation(value = "undocumented Corda Networkmap API for retrieving the caller's IP",
    response = String::class,
    produces = MediaType.TEXT_PLAIN)
  fun getMyHostname(context: RoutingContext) {
    val remote = context.request().connection().remoteAddress()
    val ia = InetAddress.getByName(remote.host())
    if (ia.isAnyLocalAddress || ia.isLoopbackAddress) {
      context.end("localhost")
    } else {
      // try to do a reverse DNS
      vertx.createDnsClient().lookup(remote.host()) {
        if (it.failed()) {
          context.end(remote.host())
        } else {
          context.end(it.result())
        }
      }
    }
  }

  private fun startCertManager(): Future<Unit> {
    return certificateManager.init()
  }

  private fun startProcessor(): Future<Unit> {
    processor = NetworkMapServiceProcessor(
      vertx = vertx,
      storages = storages,
      certificateManager = certificateManager,
      paramUpdateDelay = paramUpdateDelay
    )
    return processor.start()
  }

  private fun createHttpServerOptions(): HttpServerOptions {
    val serverOptions = HttpServerConfig.defaultServerOptions().setHost(hostname).setSsl(tls)

    return when {
      !tls -> serverOptions
      certPath.isNotBlank() && keyPath.isNotBlank() -> {
        logger.info("using cert file $certPath")
        logger.info("using key file $keyPath")
        if (!File(certPath).exists()) {
          val msg = "cert path does not exist: $certPath"
          logger.error(msg)
          throw RuntimeException(msg)
        }

        if (!File(keyPath).exists()) {
          val msg = "key path does not exist: $keyPath"
          logger.error(msg)
          throw RuntimeException(msg)
        }

        val jksOptions = CertsToJksOptionsConverter(certPath, keyPath).createJksOptions()
        serverOptions.setKeyStoreOptions(jksOptions)
      }
      else -> {
        logger.info("generating temporary TLS certificates")
        val certificate = SelfSignedCertificate.create("nms.cordakubecheck2.com")
        serverOptions
          .setKeyCertOptions(certificate.keyCertOptions())
          .setTrustOptions(certificate.trustOptions())
      }
    }
  }
}

data class SimpleNodeInfo(val nodeKey: String, val addresses: List<NetworkHostAndPort>, val parties: List<NameAndKey>, val platformVersion: Int)
data class SimpleNotaryInfo(val nodeKey: String, val notaryInfo: NotaryInfo)
data class NameAndKey(val name: CordaX500Name, val key: PublicKey)

