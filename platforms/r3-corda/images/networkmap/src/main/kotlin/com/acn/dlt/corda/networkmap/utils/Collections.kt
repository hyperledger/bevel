package com.acn.dlt.corda.networkmap.utils

import java.util.*

fun <T> Sequence<T>.toEnumeration() = asIterable().toEnumeration()
fun <T> Iterable<T>.toEnumeration(): Enumeration<T> {
  val iterator = this.iterator()
  return object : Enumeration<T> {
    override fun hasMoreElements(): Boolean {
      return iterator.hasNext()
    }

    override fun nextElement(): T {
      return iterator.next()
    }
  }
}