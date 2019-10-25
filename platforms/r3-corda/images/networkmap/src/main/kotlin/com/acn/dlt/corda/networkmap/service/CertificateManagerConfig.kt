package com.acn.dlt.corda.networkmap.service

import net.corda.core.identity.CordaX500Name
import net.corda.nodeapi.internal.crypto.CertificateAndKeyPair
import org.bouncycastle.asn1.x500.style.BCStyle
import org.bouncycastle.asn1.x500.style.IETFUtils
import org.bouncycastle.cert.jcajce.JcaX509CertificateHolder
import java.io.File
import java.io.FileInputStream
import java.security.KeyStore
import java.security.cert.CertificateFactory
import java.security.cert.PKIXParameters
import java.security.cert.TrustAnchor
import javax.net.ssl.TrustManagerFactory
import javax.net.ssl.X509TrustManager
import javax.security.auth.x500.X500Principal

class CertificateManagerConfig(
  val root: CertificateAndKeyPair = CertificateManager.createSelfSignedCertificateAndKeyPair(DEFAULT_ROOT_NAME),
  val doorManEnabled: Boolean) {

  companion object {
    val DEFAULT_ROOT_NAME = CordaX500Name("<replace me>", "DLT", "DLT", "London", "London", "GB")
  }

  val devMode = !doorManEnabled
  fun networkMapPrincipal(): X500Principal {
    val subject = JcaX509CertificateHolder(root.certificate).subject
    val o = IETFUtils.valueToString(subject.getRDNs(BCStyle.O)[0].first.value) ?: "default org"
    val l = IETFUtils.valueToString(subject.getRDNs(BCStyle.L)[0].first.value) ?: "default location"
    val c = IETFUtils.valueToString(subject.getRDNs(BCStyle.C)[0].first.value) ?: "default country"
    return X500Principal("CN=${CertificateManager.NETWORK_MAP_COMMON_NAME},O=$o,L=$l,C=$c")
  }
}
