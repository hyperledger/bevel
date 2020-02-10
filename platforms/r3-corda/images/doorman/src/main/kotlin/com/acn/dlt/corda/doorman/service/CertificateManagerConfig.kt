package com.acn.dlt.corda.doorman.service

import net.corda.core.identity.CordaX500Name
import net.corda.nodeapi.internal.crypto.CertificateAndKeyPair
import java.io.File
import java.io.FileInputStream
import java.security.KeyStore
import java.security.cert.CertificateFactory
import java.security.cert.PKIXParameters
import java.security.cert.TrustAnchor
import javax.net.ssl.TrustManagerFactory
import javax.net.ssl.X509TrustManager

class CertificateManagerConfig(
  val root: CertificateAndKeyPair = CertificateManager.createSelfSignedCertificateAndKeyPair(DEFAULT_ROOT_NAME),
  val doorManEnabled: Boolean) {
  companion object {
    val DEFAULT_ROOT_NAME = CordaX500Name("<replace me>", "FRA", "FRA", "London", "London", "GB")
  }
  val devMode = !doorManEnabled
}
