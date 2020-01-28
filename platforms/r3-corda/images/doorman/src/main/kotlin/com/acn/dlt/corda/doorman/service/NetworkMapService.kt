@file:Suppress("DEPRECATION")

package com.acn.dlt.corda.doorman.service

import com.mongodb.reactivestreams.client.MongoClient
import io.bluebank.braid.corda.BraidConfig
import io.bluebank.braid.corda.rest.AuthSchema
import io.bluebank.braid.corda.rest.RestConfig
import io.bluebank.braid.core.http.HttpServerConfig
import com.acn.dlt.corda.doorman.serialisation.SerializationEnvironment
import com.acn.dlt.corda.doorman.serialisation.deserializeOnContext
import com.acn.dlt.corda.doorman.utils.*
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
import net.corda.core.identity.CordaX500Name
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
import java.time.Duration
import java.util.zip.ZipEntry
import java.util.zip.ZipOutputStream
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
  internal val certificateManager = CertificateManager(vertx, storages.certAndKeys, certificateManagerConfig)

  fun startup(): Future<Unit> {
    // N.B. Ordering is important here
    return storages.setupStorage()
            .compose { startCertManager() }
            .compose { startupBraid() }
  }

  private fun startupBraid(): Future<Unit> {
    try {
      val thisService = this
      val result = Future.future<Unit>()
      BraidConfig()
              .withVertx(vertx)
              .withPort(port)
              .withAuthConstructor(authService::createAuthProvider)
              .withService("admin", adminService)
              .withRootPath(adminBraidRoot)
              .withHttpServerOptions(createHttpServerOptions())
              .withRestConfig(RestConfig("Network Map Service")
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
                        if (certificateManagerConfig.doorManEnabled) {
                          group("doorman") {
                            unprotected {
                              post("/certificate", thisService::postCSR)
                              get("/certificate/:id", thisService::retrieveCSRResult)
                            }
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

  private fun startCertManager(): Future<Unit> {
    return certificateManager.init()
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


