package com.acn.dlt.corda.doorman.storage.mongo

import com.mongodb.reactivestreams.client.MongoClient
import com.acn.dlt.corda.doorman.keystore.toKeyStore
import com.acn.dlt.corda.doorman.serialisation.deserializeOnContext
import com.acn.dlt.corda.doorman.storage.file.CertificateAndKeyPairStorage
import net.corda.nodeapi.internal.SignedNodeInfo
import net.corda.nodeapi.internal.crypto.CertificateAndKeyPair
import net.corda.nodeapi.internal.network.ParametersUpdate
import net.corda.nodeapi.internal.network.SignedNetworkParameters
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer
import java.security.KeyPair
import java.security.KeyStore
import java.security.PrivateKey
import java.security.cert.X509Certificate

class SignedNodeInfoStorage(client: MongoClient, databaseName: String, bucketName: String = DEFAULT_BUCKET_NAME)
  : AbstractMongoFileStorage<SignedNodeInfo>(client, databaseName, bucketName) {
  companion object {
    const val DEFAULT_BUCKET_NAME = "nodes"
  }

  override fun deserialize(data: ByteArray): SignedNodeInfo {
    return data.deserializeOnContext()
  }
}

class ParametersUpdateStorage(client: MongoClient, databaseName: String, bucketName: String = DEFAULT_BUCKET_NAME)
  : AbstractMongoFileStorage<ParametersUpdate>(client, databaseName, bucketName){
  companion object {
    const val DEFAULT_BUCKET_NAME = "parameters-update"
  }

  override fun deserialize(data: ByteArray): ParametersUpdate {
    return data.deserializeOnContext()
  }
}


class SignedNetworkParametersStorage(client: MongoClient, databaseName: String, bucketName: String = DEFAULT_BUCKET_NAME)
  : AbstractMongoFileStorage<SignedNetworkParameters>(client, databaseName, bucketName){
  companion object {
    const val DEFAULT_BUCKET_NAME = "signed-network-parameters"
  }

  override fun deserialize(data: ByteArray): SignedNetworkParameters {
    return data.deserializeOnContext()
  }
}

class CertificateAndKeyPairStorage(client: MongoClient, databaseName: String, bucketName: String = DEFAULT_BUCKET_NAME, val password: String = DEFAULT_PASSWORD)
  : AbstractMongoFileStorage<CertificateAndKeyPair>(client, databaseName, bucketName){
  companion object {
    const val DEFAULT_BUCKET_NAME = "certs"
    const val DEFAULT_KEY_ALIAS = "key"
    const val DEFAULT_CERT_ALIAS = "cert"
    const val DEFAULT_PASSWORD = "changeme"
  }

  private val pwArray = password.toCharArray()

  override fun deserialize(data: ByteArray): CertificateAndKeyPair {
    val ks = KeyStore.getInstance("JKS")
    ks.load(ByteArrayInputStream(data), pwArray)
    val pk = ks.getKey(DEFAULT_KEY_ALIAS, pwArray) as PrivateKey
    val cert = ks.getCertificate(DEFAULT_CERT_ALIAS) as X509Certificate
    return CertificateAndKeyPair(cert, KeyPair(cert.publicKey, pk))
  }

  override fun serialize(value: CertificateAndKeyPair): ByteBuffer {
    val ks = value.toKeyStore(CertificateAndKeyPairStorage.DEFAULT_CERT_ALIAS, CertificateAndKeyPairStorage.DEFAULT_KEY_ALIAS, password)
    return with(ByteArrayOutputStream()) {
      ks.store(this, pwArray)
      this.toByteArray()
    }.let { ByteBuffer.wrap(it) }
  }

}


