package com.acn.dlt.corda.doorman.service

import com.acn.dlt.corda.doorman.storage.mongo.CertificateAndKeyPairStorage
import com.acn.dlt.corda.doorman.utils.mapUnit
import com.acn.dlt.corda.doorman.utils.onSuccess
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
import net.corda.nodeapi.internal.DEV_INTERMEDIATE_CA
import net.corda.nodeapi.internal.DEV_ROOT_CA
import net.corda.nodeapi.internal.crypto.CertificateAndKeyPair
import net.corda.nodeapi.internal.crypto.CertificateType
import net.corda.nodeapi.internal.crypto.X509Utilities
import org.bouncycastle.asn1.ASN1ObjectIdentifier
import org.bouncycastle.openssl.jcajce.JcaPEMKeyConverter
import org.bouncycastle.pkcs.PKCS10CertificationRequest
import java.security.PublicKey
import java.security.cert.X509Certificate
import java.util.*
import javax.security.auth.x500.X500Principal


class CertificateManager(
    private val vertx: Vertx,
    private val storage: CertificateAndKeyPairStorage,
    private val config: CertificateManagerConfig) {

  companion object {
    private val logger = loggerFor<CertificateManager>()
    const val ROOT_CERT_KEY = "root"
    const val DOORMAN_CERT_KEY = "doorman"
    private const val ROOT_COMMON_NAME = "Root CA"
    private const val DOORMAN_COMMON_NAME = "Doorman"

    fun createSelfSignedCertificateAndKeyPair(name: CordaX500Name,
                                              signatureScheme: SignatureScheme = Crypto.ECDSA_SECP256R1_SHA256): CertificateAndKeyPair {
      val keyPair = Crypto.generateKeyPair(signatureScheme)
      val certificate = X509Utilities.createSelfSignedCACertificate(
        subject = name.x500Principal, keyPair = keyPair
      )
      return CertificateAndKeyPair(certificate, keyPair)
    }

  }

  private val csrResponse = mutableMapOf<String, Optional<X509Certificate>>()
  lateinit var doormanCertAndKeyPair: CertificateAndKeyPair
    private set
  lateinit var rootCertificateAndKeyPair: CertificateAndKeyPair
    private set

  fun init(): Future<Unit> {
    return ensureRootCertExists()
      .compose { ensureDoormanCertExists().onSuccess { doormanCertAndKeyPair = it } }
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

  private fun certTypeFor(role: CertRole): CertificateType = when (role) {
    CertRole.SERVICE_IDENTITY -> CertificateType.SERVICE_IDENTITY
    else -> CertificateType.NODE_CA
  }

  fun doormanProcessCSR(pkcs10Holder: PKCS10CertificationRequest): Future<String> {
    val id = UUID.randomUUID().toString()
    csrResponse[id] = Optional.empty()
    vertx.runOnContext {
      try {
        val nodePublicKey = JcaPEMKeyConverter().getPublicKey(pkcs10Holder.subjectPublicKeyInfo)
        val name = pkcs10Holder.subject.toCordaX500Name(true)
        val certificate = createCertificate(doormanCertAndKeyPair, name, nodePublicKey, certTypeFor(pkcs10Holder.getCertRole()))
        csrResponse[id] = Optional.of(certificate)
      } catch (err: Throwable) {
        logger.error("failed to create certificate for CSR", err)
      }
    }
    return succeededFuture(id)
  }

  fun doormanRetrieveCSRResponse(id: String): Array<X509Certificate> {
    val response = csrResponse[id]
    return if (response != null && response.isPresent) {
      arrayOf(response.get(), doormanCertAndKeyPair.certificate, rootCertificateAndKeyPair.certificate)
    } else {
      arrayOf()
    }
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
          // but because we're creating a new root key, delete the old doorman and doorman keys
          .compose {
            logger.info("clearing doorman cert")
            storage.delete(DOORMAN_CERT_KEY)
          }.recover { succeededFuture(Unit) }
          .map { cert }
      }
      .onSuccess { rootCertificateAndKeyPair = it }
      .mapUnit()
  }

  private fun ensureDoormanCertExists(): Future<CertificateAndKeyPair> {
    logger.info("checking for ${"doorman"} certificate")
    return storage.get(DOORMAN_CERT_KEY)
      .onSuccess { logger.info("${"doorman"} certificate found") }
      .recover {
        // we couldn't find the cert - so generate one
        logger.warn("failed to find ${"doorman"} certificate. generating a new cert")
        val cert = if (config.devMode) {
          logger.info("in dev mode so using the dev intermediate cert for doorman")
          DEV_INTERMEDIATE_CA
        } else {
          createCertificateAndKeyPair(rootCertificateAndKeyPair,
            CordaX500Name.build(config.root.certificate.issuerX500Principal).copy(commonName = DOORMAN_COMMON_NAME),
            CertificateType.INTERMEDIATE_CA)
        }

        storage.put(DOORMAN_CERT_KEY, cert).map { cert }
      }
  }

  internal fun createCertificateAndKeyPair(
    rootCa: CertificateAndKeyPair,
    name: CordaX500Name,
    certificateType: CertificateType,
    signatureScheme: SignatureScheme = Crypto.ECDSA_SECP256R1_SHA256
  ): CertificateAndKeyPair {
    return createCertificate(rootCa, name.x500Principal, certificateType, signatureScheme)
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

  private fun createCertificate(
    rootCa: CertificateAndKeyPair,
    name: CordaX500Name,
    publicKey: PublicKey,
    certificateType: CertificateType
  ): X509Certificate {
    return X509Utilities.createCertificate(
      certificateType = certificateType,
      issuerCertificate = rootCa.certificate,
      issuerKeyPair = rootCa.keyPair,
      subject = name.x500Principal,
      subjectPublicKey = publicKey
    )
  }
}