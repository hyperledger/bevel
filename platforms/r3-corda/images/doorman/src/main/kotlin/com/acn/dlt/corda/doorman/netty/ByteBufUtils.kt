package com.acn.dlt.corda.doorman.netty

import io.netty.buffer.ByteBuf
import io.netty.util.CharsetUtil
import io.netty.util.concurrent.FastThreadLocal
import io.netty.util.internal.PlatformDependent
import io.netty.util.internal.StringUtil
import java.nio.charset.Charset

private const val MAX_TL_ARRAY_LEN = 1024

fun ByteBuf.decodeString(charset: Charset): String {
  return decodeString(readerIndex(), readableBytes(), charset)
}

fun ByteBuf.decodeString(readerIndex: Int, len: Int, charset: Charset): String {
  if (len == 0) {
    return StringUtil.EMPTY_STRING
  }
  val (array, offset) = if (hasArray()) {
    array() to arrayOffset() + readerIndex
  } else {
    val a = threadLocalTempArray(len)
    val o = 0
    getBytes(readerIndex, a, 0, len)
    a to o
  }

  if (CharsetUtil.US_ASCII == charset) {
    // Fast-path for US-ASCII which is used frequently.
    return String(array, offset, len)
  }
  return String(array, offset, len, charset)
}

fun threadLocalTempArray(minLength: Int): ByteArray {
  return if (minLength <= MAX_TL_ARRAY_LEN) {
    BYTE_ARRAYS.get()
  } else {
    PlatformDependent.allocateUninitializedArray(minLength)
  }
}

private val BYTE_ARRAYS = object : FastThreadLocal<ByteArray>() {
  override fun initialValue(): ByteArray {
    return PlatformDependent.allocateUninitializedArray(MAX_TL_ARRAY_LEN)
  }
}
