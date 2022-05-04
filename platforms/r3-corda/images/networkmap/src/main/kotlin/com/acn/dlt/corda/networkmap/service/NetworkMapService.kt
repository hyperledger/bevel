@file:Suppress("DEPRECATION")

package com.acn.dlt.corda.networkmap.service

import io.bluebank.braid.corda.BraidConfig
import io.bluebank.braid.corda.rest.AuthSchema
import io.bluebank.braid.corda.rest.RestConfig
import io.bluebank.braid.core.async.mapUnit
import io.bluebank.braid.core.http.HttpServerConfig
import io.bluebank.braid.core.http.write
import com.acn.dlt.corda.networkmap.serialisation.NetworkParametersMixin
import com.acn.dlt.corda.networkmap.serialisation.SerializationEnvironment
import com.acn.dlt.corda.networkmap.serialisation.deserializeOnContext
import com.acn.dlt.corda.networkmap.serialisation.serializeOnContext
import com.acn.dlt.corda.networkmap.service.CertificateManager.Companion.ROOT_CERT_KEY
import com.acn.dlt.corda.networkmap.storage.file.CertificateAndKeyPairStorage.Companion.DEFAULT_CHILD_DIR
import com.acn.dlt.corda.networkmap.storage.file.CertificateAndKeyPairStorage.Companion.DEFAULT_JKS_FILE
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
import io.vertx.core.json.Json
import io.vertx.core.net.SelfSignedCertificate
import io.vertx.ext.web.RoutingContext
import io.vertx.ext.web.handler.StaticHandler
import io.vertx.kotlin.core.json.get
import net.corda.core.crypto.SecureHash
import net.corda.core.crypto.SignedData
import net.corda.core.identity.CordaX500Name
import net.corda.core.node.NetworkParameters
import net.corda.core.node.NotaryInfo
import net.corda.core.utilities.NetworkHostAndPort
import net.corda.core.utilities.loggerFor
import net.corda.nodeapi.internal.SignedNodeInfo
import org.bouncycastle.pkcs.PKCS10CertificationRequest
import java.io.ByteArrayOutputStream
import java.io.File
import java.net.HttpURLConnection
import java.net.InetAddress
import java.security.PublicKey
import java.util.zip.ZipEntry
import java.util.zip.ZipOutputStream
import javax.ws.rs.core.HttpHeaders
import javax.ws.rs.core.HttpHeaders.*
import javax.ws.rs.core.MediaType

class NetworkMapService(
  private val nmsOptions: NMSOptions,
  private val vertx: Vertx = Vertx.vertx()) {
  companion object {
    internal const val NETWORK_MAP_ROOT = "/network-map"
    internal const val ADMIN_REST_ROOT = "/admin/api"
    internal const val CERTMAN_REST_ROOT = "/certman/api"
    private const val ADMIN_BRAID_ROOT = "/braid/api"
    private const val SWAGGER_ROOT = "/swagger"
    private val logger = loggerFor<NetworkMapService>()
    
    init {
      SerializationEnvironment.init()
    }
  }
  
  private val certificateManagerConfig: CertificateManagerConfig = CertificateManagerConfig(
    root = nmsOptions.rootCA,
    doorManEnabled = nmsOptions.enableDoorman,
    certManEnabled = nmsOptions.enableCertman,
    certManPKIVerficationEnabled = nmsOptions.pkix,
    certManRootCAsTrustStoreFile = nmsOptions.truststore,
    certManRootCAsTrustStorePassword = nmsOptions.trustStorePassword,
    certManStrictEVCerts = nmsOptions.strictEV)
  
  
  private val buildProperties = NMSProperties.acquireProperties()
  private val root = nmsOptions.webRoot.dropLastWhile { it == '/' }
  
  private val adminBraidRoot: String = root + ADMIN_BRAID_ROOT
  private val swaggerRoot: String = root + SWAGGER_ROOT
  
  internal val storages = ServiceStorages.create(vertx, nmsOptions)
  private val adminService = AdminServiceImpl()
  internal lateinit var processor: NetworkMapServiceProcessor
  private val authService = AuthService(nmsOptions.authProvider)
  internal val certificateManager = CertificateManager(vertx, storages.certAndKeys, certificateManagerConfig)
  private val rootCAFilePath = nmsOptions.rootCAFilePath
  
  fun startup(): Future<Unit> {
    // N.B. Ordering is important here
    if(rootCAFilePath.isNotBlank())
      storeRootCertInStorage()
    return storages.setupStorage()
      .compose { startCertManager() }
      .compose { startProcessor() }
      .compose { startupBraid() }
  }
  
  fun shutdown(): Future<Unit> {
    processor.stop()
    return Future.succeededFuture(Unit)
  }
  private fun storeRootCertInStorage(){
    val rootFile = File("${nmsOptions.dbDirectory}/$DEFAULT_CHILD_DIR/$ROOT_CERT_KEY")
    rootFile.mkdirs()
    val fileBuffer = vertx.fileSystem().readFileBlocking(nmsOptions.rootCAFilePath)
    vertx.fileSystem().writeFileBlocking("${rootFile.absolutePath}/$DEFAULT_JKS_FILE", fileBuffer)
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
        .withPort(nmsOptions.port)
        .withAuthConstructor(authService::createAuthProvider)
        .withService("admin", adminService)
        .withRootPath(adminBraidRoot)
        .withHttpServerOptions(createHttpServerOptions())
        .withRestConfig(RestConfig("Network Map Service")
          .withAuthSchema(AuthSchema.Token)
          .withSwaggerPath(swaggerRoot)
          .withApiPath("$root/") // a little different because we need to mount the network map on '/network-map'
          .withContact(Contact().url("https://www.company.com").name("Company, Inc."))
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
                post("$NETWORK_MAP_ROOT/ack-parameters", thisService::ackNetworkParametersUpdate)
                get("$NETWORK_MAP_ROOT/node-info/:hash", thisService::getNodeInfo)
                get("$NETWORK_MAP_ROOT/network-parameters/:hash", thisService::getNetworkParameter)
                get("$NETWORK_MAP_ROOT/my-hostname", thisService::getMyHostname)
                get("$NETWORK_MAP_ROOT/truststore", thisService::getNetworkTrustStore)
                get("$NETWORK_MAP_ROOT/distributed-service/", thisService::getDistributedServiceKey)
              }
            }
            if (certificateManagerConfig.doorManEnabled) {
              group("doorman") {
                unprotected {
                  post("/certificate", thisService::postCSR)
                  get("/certificate/:id", thisService::retrieveCSRResult)
                }
              }
            }
            if (certificateManagerConfig.certManEnabled) {
              group("certman") {
                unprotected {
                  post("$CERTMAN_REST_ROOT/generate", certificateManager::certmanGenerate)
                }
              }
            }
            group("admin") {
              unprotected {
                post("$ADMIN_REST_ROOT/login", authService::login)
                get("$ADMIN_REST_ROOT/whitelist", processor::serveWhitelist)
                get("$ADMIN_REST_ROOT/notaries", processor::serveNotaries)
                get("$ADMIN_REST_ROOT/nodes", processor::serveNodes)
                get("$ADMIN_REST_ROOT/nodes/paging-summary", processor::nodeInfoPagingSummary)
                get("$ADMIN_REST_ROOT/nodes/page", processor::getNodeInfoByPage)
                get("$ADMIN_REST_ROOT/network-parameters", processor::getAllNetworkParameters)
                get("$ADMIN_REST_ROOT/network-parameters/current", processor::getCurrentNetworkParameters)
                get("$ADMIN_REST_ROOT/build-properties", thisService::serveProperties)
                get("$ADMIN_REST_ROOT/network-map", processor::getCurrentNetworkMap)
                router {
                  route("/").handler { context ->
                    if (context.request().path() == root) {
                      context.response().putHeader(LOCATION, "$root/").setStatusCode(HttpResponseStatus.MOVED_PERMANENTLY.code()).end()
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
                delete("$ADMIN_REST_ROOT/nodes/", processor::deleteAllNodes)
                post("$ADMIN_REST_ROOT/replaceAllNetworkParameters", processor::replaceAllNetworkParameters)
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
  
  internal fun addNotaryInfos(notaryInfos: List<NotaryInfo>): Future<String> {
    return processor.addNotaryInfos(notaryInfos)
  }
  
  @Suppress("MemberVisibilityCanBePrivate")
  @ApiOperation(value = "Retrieve the current signed network map object. The entire object is signed with the network map certificate which is also attached.",
    produces = MediaType.APPLICATION_OCTET_STREAM, response = Buffer::class)
  fun serveNetworkMap(context: RoutingContext) {
    processor.createSignedNetworkMap()
      .onSuccess { snm ->
        context.response().apply {
          setCacheControl(nmsOptions.cacheTimeout)
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
  @ApiOperation(value = "Receives a certificate signing request",
    consumes = MediaType.APPLICATION_OCTET_STREAM
  )
  fun postCSR(pkcS10CertificationRequest: Buffer): Future<String> {
    val csr = PKCS10CertificationRequest(pkcS10CertificationRequest.bytes)
    return certificateManager.doormanProcessCSR(csr)
  }
  
  @Suppress("MemberVisibilityCanBePrivate")
  @ApiOperation(value = "Retrieve the certificate chain as a zipped binary block")
  fun retrieveCSRResult(routingContext: RoutingContext) {
    try {
      val id = routingContext.request().getParam("id")
      val certificates = certificateManager.doormanRetrieveCSRResponse(id)
      if (certificates.isEmpty()) {
        routingContext.response().setStatusCode(HttpURLConnection.HTTP_NO_CONTENT).end()
      } else {
        val bytes = ByteArrayOutputStream().use {
          ZipOutputStream(it).use { zipStream ->
            certificates.forEach { certificate ->
              zipStream.putNextEntry(ZipEntry(certificate.subjectX500Principal.name))
              zipStream.write(certificate.encoded)
              zipStream.closeEntry()
            }
          }
          it.toByteArray()
        }
        routingContext.response().apply {
          putHeader(CONTENT_TYPE, MediaType.APPLICATION_OCTET_STREAM)
          putHeader(CONTENT_LENGTH, bytes.size.toString())
          end(Buffer.buffer(bytes))
        }
      }
    } catch (err: Throwable) {
      routingContext.response().setStatusMessage(err.message).setStatusCode(HttpURLConnection.HTTP_UNAUTHORIZED).end()
    }
  }
  
  @Suppress("MemberVisibilityCanBePrivate")
  @ApiOperation(value = "For the node operator to acknowledge network map that new parameters were accepted for future update.",
    consumes = MediaType.APPLICATION_OCTET_STREAM)
  fun ackNetworkParametersUpdate(routingContext: RoutingContext) {
    val body = routingContext.body
    val signedParameterHash = body.bytes.deserializeOnContext<SignedData<SecureHash>>()
    storages.getCurrentNetworkParametersHash()
      .onSuccess {
        if (it == signedParameterHash.verified()) {
          storages.storeLatestParametersAccepted(signedParameterHash)
            // Todo add code to retrieve node info based on the key from nodeInfo storage and change the log message to print node details
            .onSuccess { result ->
              logger.info("Acknowledged network parameters $result saved against the node public key ${signedParameterHash.sig.by}")
              routingContext.response().setStatusCode(HttpURLConnection.HTTP_OK).end()
            }
            .catch { err ->
              logger.info("failed to save acknowledged network parameters against the node public key", err)
            }
        } else {
          routingContext.response().setStatusMessage("network parameters not the latest version").setStatusCode(HttpURLConnection.HTTP_BAD_REQUEST).end()
        }
      }.catch {
        logger.error("failed to acknowledge the network parameters sent by node public key ${signedParameterHash.sig.by}")
        routingContext.end(it)
      }
  }
  
  fun latestParametersAccepted(publicKey: PublicKey): Future<SecureHash> {
    return storages.latestParametersAccepted(publicKey)
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
          setCacheControl(nmsOptions.cacheTimeout)
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
          setCacheControl(nmsOptions.cacheTimeout)
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
  
  @Suppress("MemberVisibilityCanBePrivate")
  @ApiOperation(value = "To generate and retrieve the distributed service key for notary cluster",
    response = Buffer::class,
    produces = MediaType.APPLICATION_OCTET_STREAM)
  fun getDistributedServiceKey(context: RoutingContext) {
    try {
      val payload = context.bodyAsJson
      val x500Name = CordaX500Name.parse(payload["x500Name"])
      logger.info("generating distributed service jks files for $x500Name")
      val stream = certificateManager.generateDistributedServiceKey(x500Name)
      context.response().apply {
        putHeader(CONTENT_TYPE, HttpHeaderValues.APPLICATION_OCTET_STREAM)
        putHeader(CONTENT_DISPOSITION, "attachment; filename=\"distributedService.jks\"")
        end(Buffer.buffer(stream))
      }
    } catch (err: Throwable) {
      logger.error("failed to generate jks files", err)
      context.write(err)
    }
  }
  
  @ApiOperation(value = "get the build-time properties")
  fun serveProperties() = buildProperties
  
  private fun startCertManager(): Future<Unit> {
    return certificateManager.init()
  }
  
  private fun startProcessor(): Future<Unit> {
    processor = NetworkMapServiceProcessor(
      vertx = vertx,
      storages = storages,
      certificateManager = certificateManager,
      paramUpdateDelay = nmsOptions.paramUpdateDelay,
      allowNodeKeyChange = nmsOptions.allowNodeKeyChange
    )
    return createNetworkParameters().map{
      processor.start(it)
    }. mapUnit()
  }
  
  private fun createHttpServerOptions(): HttpServerOptions {
    val serverOptions = HttpServerConfig.defaultServerOptions().setHost(nmsOptions.hostname).setSsl(nmsOptions.tls)
    
    return when {
      !nmsOptions.tls -> serverOptions
      nmsOptions.certPath.isNotBlank() && nmsOptions.keyPath.isNotBlank() -> {
        logger.info("using cert file $nmsOptions.certPath")
        logger.info("using key file $nmsOptions.keyPath")
        if (!File(nmsOptions.certPath).exists()) {
          val msg = "cert path does not exist: ${nmsOptions.certPath}"
          logger.error(msg)
          throw RuntimeException(msg)
        }
        
        if (!File(nmsOptions.keyPath).exists()) {
          val msg = "key path does not exist: ${nmsOptions.keyPath}"
          logger.error(msg)
          throw RuntimeException(msg)
        }
        
        val jksOptions = CertsToJksOptionsConverter(nmsOptions.certPath, nmsOptions.keyPath).createJksOptions()
        serverOptions.setKeyStoreOptions(jksOptions)
      }
      else -> {
        logger.info("generating temporary TLS certificates")
        val certificate = SelfSignedCertificate.create()
        serverOptions
          .setKeyCertOptions(certificate.keyCertOptions())
          .setTrustOptions(certificate.trustOptions())
      }
    }
  }
  
  private fun createNetworkParameters(): Future<NetworkParameters> {
    val networkParameters: NetworkParameters = if (nmsOptions.networkParametersPath.isNotEmpty()) {
      if (!File(nmsOptions.networkParametersPath).exists()) {
        val msg = "network parameters path does not exist: ${nmsOptions.networkParametersPath}"
        logger.error(msg)
        throw RuntimeException(msg)
      } else {
        val buffer = vertx.fileSystem().readFileBlocking(nmsOptions.networkParametersPath)
        val mixedIn: NetworkParametersMixin = Json.decodeValue(buffer, NetworkParametersMixin::class.java)
        Json.mapper.convertValue(mixedIn, NetworkParameters::class.java)
      }
    } else {
      Json.mapper.convertValue(NetworkParametersMixin(), NetworkParameters::class.java)
    }
    return Future.succeededFuture(networkParameters)
  }
}

data class SimpleNodeInfo(val nodeKey: String, val addresses: List<NetworkHostAndPort>, val parties: List<NameAndKey>, val platformVersion: Int)
data class SimpleNotaryInfo(val nodeKey: String, val notaryInfo: NotaryInfo)
data class NameAndKey(val name: CordaX500Name, val key: PublicKey)

