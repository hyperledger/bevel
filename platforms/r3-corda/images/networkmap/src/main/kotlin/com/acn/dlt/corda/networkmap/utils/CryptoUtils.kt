package com.acn.dlt.corda.networkmap.utils

import net.corda.core.crypto.Crypto
import net.corda.core.internal.SignedDataWithCert
import net.corda.core.internal.signWithCert
import net.corda.nodeapi.internal.crypto.CertificateAndKeyPair
import java.security.PrivateKey
import java.util.*

object CryptoUtils {
  fun decodePEMPrivateKey(pem: String): PrivateKey {
    val encodedPrivKey = Base64.getDecoder().decode(pem.lines().filter { !it.startsWith("---") }.joinToString(separator = ""))
    return Crypto.decodePrivateKey(encodedPrivKey)
  }
}

inline fun <reified T : Any> T.sign(certs: CertificateAndKeyPair): SignedDataWithCert<T> {
  return signWithCert(certs.keyPair.private, certs.certificate)
}
