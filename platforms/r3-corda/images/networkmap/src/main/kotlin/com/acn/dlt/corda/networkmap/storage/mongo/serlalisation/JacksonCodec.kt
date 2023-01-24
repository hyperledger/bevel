package com.acn.dlt.corda.networkmap.storage.mongo.serlalisation

import com.fasterxml.jackson.databind.ObjectMapper
import org.bson.BsonReader
import org.bson.BsonWriter
import org.bson.RawBsonDocument
import org.bson.codecs.Codec
import org.bson.codecs.DecoderContext
import org.bson.codecs.EncoderContext
import org.bson.codecs.configuration.CodecRegistry
import java.io.IOException
import java.io.UncheckedIOException

internal class JacksonCodec<T>(private val bsonObjectMapper: ObjectMapper,
                               codecRegistry: CodecRegistry,
                               private val type: Class<T>) : Codec<T> {
  private val rawBsonDocumentCodec: Codec<RawBsonDocument> = codecRegistry.get(RawBsonDocument::class.java)

  override fun decode(reader: BsonReader, decoderContext: DecoderContext): T {
    try {
      val document = rawBsonDocumentCodec.decode(reader, decoderContext)
      return bsonObjectMapper.readValue(document.byteBuffer.array(), type)
    } catch (e: IOException) {
      throw UncheckedIOException(e)
    }
  }

  override fun encode(writer: BsonWriter?, value: T, encoderContext: EncoderContext?) {
    try {
      val data = bsonObjectMapper.writeValueAsBytes(value)
      rawBsonDocumentCodec.encode(writer, RawBsonDocument(data), encoderContext)
    } catch (e: IOException) {
      throw UncheckedIOException(e)
    }
  }

  override fun getEncoderClass(): Class<T> {
    return this.type
  }
}