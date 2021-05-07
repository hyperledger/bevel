package com.acn.dlt.corda.networkmap.service

import net.corda.core.identity.CordaX500Name
import org.bouncycastle.asn1.x500.X500Name
import java.security.cert.CertPathValidator
import java.security.cert.X509Certificate


class CertificateRequestPayload(
  private val certs: List<X509Certificate>,
  private val signature: ByteArray,
  private val certificateManagerConfig: CertificateManagerConfig
) {
  companion object {
    private val certPathValidator = CertPathValidator.getInstance("PKIX")
  }

  val x500Name: CordaX500Name by lazy {
    val x500 = X500Name.getInstance(certs.first().subjectX500Principal.encoded)
    x500.toCordaX500Name(certificateManagerConfig.certManStrictEVCerts)
  }

  fun verify() {
    certs.forEach { it.checkValidity() }
    if (certificateManagerConfig.certManPKIVerficationEnabled) {
      verifyPKIPath()
    }
    verifySignature()
  }

  private fun verifyPKIPath() {
    val certPath = certificateManagerConfig.certFactory.generateCertPath(certs)
    certPathValidator.validate(certPath, certificateManagerConfig.pkixParams)
  }

  private fun verifySignature() {
    CertificateManager.createSignature().apply {
      initVerify(certs.first())
      verify(signature)
    }
  }
}

