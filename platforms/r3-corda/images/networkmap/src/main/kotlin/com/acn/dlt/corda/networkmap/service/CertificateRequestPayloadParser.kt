package com.acn.dlt.corda.networkmap.service

import net.corda.core.utilities.loggerFor
import org.jgroups.util.Base64
import java.io.ByteArrayInputStream
import java.security.KeyStore
import java.security.cert.CertificateFactory
import java.security.cert.PKIXParameters
import java.security.cert.TrustAnchor
import java.security.cert.X509Certificate
import javax.net.ssl.TrustManagerFactory
import javax.net.ssl.X509TrustManager

class CertificateRequestPayloadParser(private val certManContext: CertificateManagerConfig) {
  companion object {
    private val log = loggerFor<CertificateRequestPayloadParser>()
    private const val BEGIN_CERTIFICATE_TOKEN = "-----BEGIN CERTIFICATE-----"
    private const val END_CERTIFICATE_TOKEN = "-----END CERTIFICATE-----"
  }

  private var pkixParams: PKIXParameters
  private var certFactory: CertificateFactory

  init {
    val trustManager = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm())
      .apply { init(null as KeyStore?) }
      .trustManagers
      .filter { it is X509TrustManager }
      .map { it as X509TrustManager }
      .firstOrNull() ?: throw Exception("could not find the default x509 trust manager")

    val trustAnchors = trustManager.acceptedIssuers.map { TrustAnchor(it, null) }.toSet()
    pkixParams = PKIXParameters(trustAnchors).apply { isRevocationEnabled = false }
    certFactory = CertificateFactory.getInstance("X.509")
  }

  fun parse(body: String): CertificateRequestPayload {
    val parts = body.split(END_CERTIFICATE_TOKEN)
    if (parts.size < 2) {
      throw RuntimeException("payload must be a set of certs followed by signature")
    }
    val certs = parts.dropLast(1).map { it + END_CERTIFICATE_TOKEN }.map { readCertificate(it) }
    val signatureText = parts.last()
    val sig = Base64.decode(signatureText)
    return CertificateRequestPayload(certs, sig, certManContext)
  }

  private fun readCertificate(certText: String): X509Certificate {
    try {
      val pem = Base64.decode(certText.replace(BEGIN_CERTIFICATE_TOKEN, "").replace(END_CERTIFICATE_TOKEN, ""))
      return certFactory.generateCertificate(ByteArrayInputStream(pem)) as X509Certificate
    } catch (ex: Throwable) {
      log.error("failed to read certificate", ex)
      throw ex
    }
  }
}