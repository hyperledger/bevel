package com.acn.dlt.corda.networkmap.service

import com.acn.dlt.corda.networkmap.keystore.toKeyStore
import com.acn.dlt.corda.networkmap.storage.mongo.CertificateAndKeyPairStorage
import com.acn.dlt.corda.networkmap.utils.mapUnit
import com.acn.dlt.corda.networkmap.utils.onSuccess
import io.vertx.core.Future
import io.vertx.core.Future.succeededFuture
import io.vertx.core.Vertx
import net.corda.core.CordaOID
import net.corda.core.crypto.Crypto
import net.corda.core.crypto.SignatureScheme
import net.corda.core.identity.CordaX500Name
import net.corda.core.internal.CertRole
import net.corda.core.node.NodeInfo
import net.corda.core.utilities.loggerFor
import net.corda.nodeapi.internal.DEV_ROOT_CA
import net.corda.nodeapi.internal.crypto.CertificateAndKeyPair
import net.corda.nodeapi.internal.crypto.CertificateType
import net.corda.nodeapi.internal.crypto.X509KeyStore
import net.corda.nodeapi.internal.crypto.X509Utilities
import org.bouncycastle.asn1.ASN1ObjectIdentifier
import org.bouncycastle.pkcs.PKCS10CertificationRequest
import java.io.ByteArrayOutputStream
import java.security.Signature
import java.security.cert.X509Certificate
import java.util.*
import java.util.zip.ZipEntry
import java.util.zip.ZipOutputStream
import javax.security.auth.x500.X500Principal


class CertificateManager(
    private val storage: CertificateAndKeyPairStorage,
    private val config: CertificateManagerConfig) {

  companion object {
    private val logger = loggerFor<CertificateManager>()
    internal const val TRUST_STORE_PASSWORD = "trustpass"
    const val ROOT_CERT_KEY = "root"
    const val NETWORK_MAP_CERT_KEY = "network-map"
    private const val ROOT_COMMON_NAME = "Root CA"
    internal const val NETWORK_MAP_COMMON_NAME = "Network Map"

    fun createSelfSignedCertificateAndKeyPair(name: CordaX500Name,
                                              signatureScheme: SignatureScheme = Crypto.ECDSA_SECP256R1_SHA256): CertificateAndKeyPair {
      val keyPair = Crypto.generateKeyPair(signatureScheme)
      val certificate = X509Utilities.createSelfSignedCACertificate(
        subject = name.x500Principal, keyPair = keyPair
      )
      return CertificateAndKeyPair(certificate, keyPair)
    }

  }

  lateinit var networkMapCertAndKeyPair: CertificateAndKeyPair
    private set
  lateinit var rootCertificateAndKeyPair: CertificateAndKeyPair
    private set

  fun init(): Future<Unit> {
    return ensureRootCertExists()
      .compose { ensureNetworkMapCertExists() }
      .map(Unit)
  }

  fun validateNodeInfoCertificates(nodeInfo: NodeInfo) {
    nodeInfo.legalIdentitiesAndCerts.forEach {
      X509Utilities.validateCertPath(rootCertificateAndKeyPair.certificate, it.certPath)
    }
  }
  private fun PKCS10CertificationRequest.getCertRole(): CertRole {
    val firstAttributeValue = getAttributes(ASN1ObjectIdentifier(CordaOID.X509_EXTENSION_CORDA_ROLE)).firstOrNull()?.attrValues?.firstOrNull()
    // Default cert role to Node_CA for backward compatibility.
    val encoded = firstAttributeValue?.toASN1Primitive()?.encoded ?: return CertRole.NODE_CA
    return CertRole.getInstance(encoded)
  }

  private fun ensureRootCertExists(): Future<Unit> {
    logger.info("checking for root certificate")
    return storage.get(ROOT_CERT_KEY)
      .onSuccess { logger.info("root certificate found") }
      .recover {
        // we couldn't find the cert - so generate one
        logger.warn("didn't find our root certificate")

        val cert = if (config.devMode) {
          DEV_ROOT_CA
        } else {
          createSelfSignedCertificateAndKeyPair(CordaX500Name.build(config.root.certificate.issuerX500Principal).copy(commonName = ROOT_COMMON_NAME))
        }

        storage.put(ROOT_CERT_KEY, cert)
          // but because we're creating a new root key, delete the old networkmap and doorman keys
          .compose {
            logger.info("clearing network-map cert")
            storage.delete(NETWORK_MAP_CERT_KEY)
          }.recover { succeededFuture(Unit) }
          .map { cert }
      }
      .onSuccess { rootCertificateAndKeyPair = it }
      .mapUnit()
  }

  private fun ensureNetworkMapCertExists(): Future<Unit> {
    return storage.get(NETWORK_MAP_CERT_KEY)
      .onSuccess { logger.info("networkmap certificate found") }
      .recover {
        // we couldn't find the cert - so generate one
        logger.warn("didn't find networkmap certificate")
        val cert =
          createCertificateAndKeyPair(
            rootCertificateAndKeyPair,
            config.networkMapPrincipal(),
            CertificateType.NETWORK_MAP,
            Crypto.ECDSA_SECP256R1_SHA256
          )

        storage.put(NETWORK_MAP_CERT_KEY, cert).map { cert }
      }
      .onSuccess { networkMapCertAndKeyPair = it }
      .mapUnit()
  }

  private fun createCertificateAndKeyPair(
    rootCa: CertificateAndKeyPair,
    name: X500Principal,
    certificateType: CertificateType,
    signatureScheme: SignatureScheme = Crypto.ECDSA_SECP256R1_SHA256
  ): CertificateAndKeyPair {
    return createCertificate(rootCa, name, certificateType, signatureScheme)
  }

  private fun createCertificate(
    rootCa: CertificateAndKeyPair,
    name: X500Principal,
    certificateType: CertificateType,
    signatureScheme: SignatureScheme = Crypto.ECDSA_SECP256R1_SHA256
  ): CertificateAndKeyPair {
    val keyPair = Crypto.generateKeyPair(signatureScheme)
    val certificate = X509Utilities.createCertificate(certificateType, rootCa.certificate, rootCa.keyPair, name, keyPair.public)
    return CertificateAndKeyPair(certificate, keyPair)
  }

  fun generateTrustStoreByteArray(): ByteArray {
    return ByteArrayOutputStream().apply {
      X509KeyStore(TRUST_STORE_PASSWORD).apply {
        setCertificate("cordarootca", rootCertificateAndKeyPair.certificate)
        setCertificate("networkmap", networkMapCertAndKeyPair.certificate)
      }.internal.store(this, TRUST_STORE_PASSWORD.toCharArray())
    }.toByteArray()
  }

}
