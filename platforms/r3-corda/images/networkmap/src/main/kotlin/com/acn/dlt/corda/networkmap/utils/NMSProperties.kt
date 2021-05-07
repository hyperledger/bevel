package com.acn.dlt.corda.networkmap.utils

import java.util.*

class NMSProperties(val properties: Map<String, String> = emptyMap()) : Map<String, String> by properties {
  companion object {
    fun acquireProperties() : NMSProperties {
      return ClassLoader.getSystemClassLoader().getResourceAsStream("nms.build.properties") ?.let { stream ->
        val properties = Properties().apply { this.load(stream) }
        val map = properties.stringPropertyNames().map { name -> name to properties.getProperty(name)!! }.toMap()
        NMSProperties(map)
      } ?: NMSProperties()
    }
  }

  val mavenVersion : String by lazy {
    this["nms.version"] ?: "unspecified"
  }

  val scmVersion : String by lazy {
    this["buildNumber"] ?: "unspecified"
  }

  override fun toString(): String {
    val maxLength = this.keys.fold(0) { acc, name -> Math.max(acc, name.length)}
    return this.map { (key, value) ->
      "${key.padEnd(maxLength)}: $value"
    }.sorted().joinToString("\n")
  }
}