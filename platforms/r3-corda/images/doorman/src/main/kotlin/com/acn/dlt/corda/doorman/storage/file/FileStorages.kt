package com.acn.dlt.corda.doorman.storage.file

import com.acn.dlt.corda.doorman.keystore.toKeyStore
import com.acn.dlt.corda.doorman.utils.readFile
import com.acn.dlt.corda.doorman.utils.writeFile
import io.netty.handler.codec.http.HttpHeaderValues
import io.vertx.core.Future
import io.vertx.core.Future.failedFuture
import io.vertx.core.Future.future
import io.vertx.core.Vertx
import io.vertx.core.buffer.Buffer
import io.vertx.core.http.HttpHeaders
import io.vertx.ext.web.RoutingContext
import net.corda.nodeapi.internal.SignedNodeInfo
import net.corda.nodeapi.internal.crypto.CertificateAndKeyPair
import net.corda.nodeapi.internal.network.ParametersUpdate
import net.corda.nodeapi.internal.network.SignedNetworkMap
import net.corda.nodeapi.internal.network.SignedNetworkParameters
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.File
import java.security.KeyPair
import java.security.KeyStore
import java.security.PrivateKey
import java.security.cert.X509Certificate
import java.time.Duration


class SignedNodeInfoStorage(
  vertx: Vertx,
  parentDirectory: File,
  childDirectory: String = DEFAULT_CHILD_DIR
) :
  AbstractFileBasedNameValueStore<SignedNodeInfo>(File(parentDirectory, childDirectory), vertx) {

  companion object {
    const val DEFAULT_CHILD_DIR = "nodes"
  }

  override fun deserialize(location: File): Future<SignedNodeInfo> {
    return AbstractFileBasedNameValueStore.deserialize(location, vertx)
  }

  override fun serialize(value: SignedNodeInfo, location: File): Future<Unit> {
    return serialize(value, location, vertx)
  }
}

class ParametersUpdateStorage(vertx: Vertx, parentDirectory: File, childDirectory: String = DEFAULT_CHILD_DIR)
  : AbstractFileBasedNameValueStore<ParametersUpdate>(File(parentDirectory, childDirectory), vertx) {
  companion object {
    const val DEFAULT_CHILD_DIR = "parameters-update"
  }

  override fun serialize(value: ParametersUpdate, location: File): Future<Unit> {
    return serialize(value, location, vertx)
  }

  override fun deserialize(location: File): Future<ParametersUpdate> {
    return deserialize(location, vertx)
  }
}

class SignedNetworkMapStorage(
  vertx: Vertx,
  parentDirectory: File,
  childDirectory: String = DEFAULT_CHILD_DIR
) :
  AbstractFileBasedNameValueStore<SignedNetworkMap>(File(parentDirectory, childDirectory), vertx) {
  companion object {
    const val DEFAULT_CHILD_DIR = "network-map"
  }

  override fun deserialize(location: File): Future<SignedNetworkMap> {
    return AbstractFileBasedNameValueStore.deserialize(location, vertx)
  }

  override fun serialize(value: SignedNetworkMap, location: File): Future<Unit> {
    return serialize(value, location, vertx)
  }
}

class SignedNetworkParametersStorage(
  vertx: Vertx,
  parentDirectory: File,
  childDirectory: String = DEFAULT_CHILD_DIR
) :
  AbstractFileBasedNameValueStore<SignedNetworkParameters>(File(parentDirectory, childDirectory), vertx) {
  companion object {
    const val DEFAULT_CHILD_DIR = "signed-network-parameters"
  }

  override fun deserialize(location: File): Future<SignedNetworkParameters> {
    return AbstractFileBasedNameValueStore.deserialize(location, vertx)
  }

  override fun serialize(value: SignedNetworkParameters, location: File): Future<Unit> {
    return serialize(value, location, vertx)
  }
}

class CertificateAndKeyPairStorage(
  vertx: Vertx,
  parentDirectory: File,
  childDirectory: String = DEFAULT_CHILD_DIR,
  val password: String = DEFAULT_PASSWORD,
  private val jksFilename: String = DEFAULT_JKS_FILE
) : AbstractFileBasedNameValueStore<CertificateAndKeyPair>(File(parentDirectory, childDirectory), vertx) {
  companion object {
    const val DEFAULT_CHILD_DIR = "certs"
    const val DEFAULT_JKS_FILE = "keys.jks"
    const val DEFAULT_KEY_ALIAS = "key"
    const val DEFAULT_CERT_ALIAS = "cert"
    const val DEFAULT_PASSWORD = "changeme"
  }

  private val parray = password.toCharArray()

  override fun deserialize(location: File): Future<CertificateAndKeyPair> {
    val file = resolveJksFile(location)
    if (!location.exists()) return failedFuture("couldn't find jks file ${file.absolutePath}")
    return vertx.fileSystem().readFile(file.absolutePath)
      .map {
        val ba = it.bytes
        val ks = KeyStore.getInstance("JKS")
        ks.load(ByteArrayInputStream(ba), parray)
        val pk = ks.getKey(DEFAULT_KEY_ALIAS, parray) as PrivateKey
        val cert = ks.getCertificate(DEFAULT_CERT_ALIAS) as X509Certificate
        CertificateAndKeyPair(cert, KeyPair(cert.publicKey, pk))
      }
  }

  override fun serialize(value: CertificateAndKeyPair, location: File): Future<Unit> {
    location.mkdirs()
    val ks = value.toKeyStore(DEFAULT_CERT_ALIAS, DEFAULT_KEY_ALIAS, password)
    val ba = with(ByteArrayOutputStream()) {
      ks.store(this, parray)
      this.toByteArray()
    }
    return vertx.fileSystem().writeFile(resolveJksFile(location).absolutePath, ba).map { Unit }
  }

  private fun resolveJksFile(directory: File) = File(directory, jksFilename)
}

class TextStorage(vertx: Vertx, parentDirectory: File, childDirectory: String = DEFAULT_CHILD_DIR) :
  AbstractFileBasedNameValueStore<String>(File(parentDirectory, childDirectory), vertx) {

  companion object {
    const val DEFAULT_CHILD_DIR = "etc"
  }

  init {
    makeDirs()
  }

  override fun deserialize(location: File): Future<String> {
    val result = future<Buffer>()
    vertx.fileSystem().readFile(location.absolutePath, result.completer())
    return result.map { it.toString() }
  }

  override fun serialize(value: String, location: File): Future<Unit> {
    val result = future<Void>()
    vertx.fileSystem().writeFile(location.absolutePath, Buffer.buffer(value), result.completer())
    return result.map { Unit }
  }

  override fun serve(key: String, routingContext: RoutingContext, cacheTimeout: Duration) {
    routingContext.response().apply {
      putHeader(HttpHeaders.CACHE_CONTROL, "max-age=${cacheTimeout.seconds}")
      putHeader(HttpHeaders.CONTENT_TYPE, HttpHeaderValues.TEXT_PLAIN)
        .sendFile(resolveKey(key).absolutePath)
    }
  }
}

