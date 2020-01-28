package com.acn.dlt.corda.doorman.storage.mongo.serlalisation

import com.fasterxml.jackson.databind.ObjectMapper
import org.bson.codecs.Codec
import org.bson.codecs.configuration.CodecProvider
import org.bson.codecs.configuration.CodecRegistry

class JacksonCodecProvider(private val bsonObjectMapper: ObjectMapper) : CodecProvider {
  override fun <T> get(type: Class<T>, registry: CodecRegistry): Codec<T> {
    return JacksonCodec(bsonObjectMapper, registry, type)
  }
}