package com.acn.dlt.corda.networkmap.keystore

import io.vertx.core.buffer.Buffer
import io.vertx.core.net.JksOptions
import net.corda.nodeapi.internal.crypto.CertificateAndKeyPair
import net.corda.nodeapi.internal.crypto.X509KeyStore
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileInputStream
import java.security.KeyStore
import java.security.cert.X509Certificate

fun File.toX509KeyStore(password: String): X509KeyStore {
  val input = FileInputStream(this)
  val keystore = KeyStore.getInstance(KeyStore.getDefaultType())
  keystore.load(input, password.toCharArray())
  return X509KeyStore(keystore, password)
}

fun KeyStore.toJksOptions(keyStorePassword: String): JksOptions {
  val buffer = ByteArrayOutputStream().use { os ->
    store(os, keyStorePassword.toCharArray())
    Buffer.buffer(os.toByteArray())
  }
  val jksOptions = JksOptions()
  jksOptions.password = keyStorePassword
  jksOptions.value = buffer
  return jksOptions
}

fun CertificateAndKeyPair.toKeyStore(certAlias: String, keyAlias: String, password: String, certPath: List<X509Certificate> = listOf()): KeyStore {
  val passwordCharArray = password.toCharArray()
  val ks = KeyStore.getInstance("JKS")
  ks.load(null, null)
  ks.setCertificateEntry(certAlias, certificate)
  val certificates = listOf(certificate) + certPath
  ks.setKeyEntry(certAlias, keyPair.private, passwordCharArray, certificates.toTypedArray())
  ks.setKeyEntry(keyAlias, keyPair.private, passwordCharArray, certificates.toTypedArray())
  return ks
}