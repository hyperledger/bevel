package com.acn.dlt.corda.networkmap.storage.mongo.serlalisation


import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.kotlin.KotlinModule
import de.undercouch.bson4jackson.BsonFactory
import de.undercouch.bson4jackson.BsonParser

object ObjectMapperFactory {
  val mapper = BsonFactory()
    .apply { enable(BsonParser.Feature.HONOR_DOCUMENT_LENGTH) }
    .let { ObjectMapper(it) }
    .apply { registerModule(KotlinModule()) }
}

