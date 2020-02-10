package com.acn.dlt.corda.networkmap.serialisation

import com.fasterxml.jackson.core.JsonGenerator
import com.fasterxml.jackson.core.JsonParser
import com.fasterxml.jackson.databind.DeserializationContext
import com.fasterxml.jackson.databind.SerializerProvider
import com.fasterxml.jackson.databind.deser.std.StdDeserializer
import com.fasterxml.jackson.databind.ser.std.StdSerializer
import net.corda.core.utilities.parsePublicKeyBase58
import net.corda.core.utilities.toBase58String
import java.security.PublicKey


class PublicKeySerializer : StdSerializer<PublicKey>(PublicKey::class.java) {
  override fun serialize(key: PublicKey, generator: JsonGenerator, provider: SerializerProvider) {
    generator.writeString(key.toBase58String())
  }
}

class PublicKeyDeserializer : StdDeserializer<PublicKey>(PublicKey::class.java) {
  override fun deserialize(parser: JsonParser, context: DeserializationContext): PublicKey {
    return parsePublicKeyBase58(parser.text)
  }
}