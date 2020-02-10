package com.acn.dlt.corda.doorman.storage.mongo

import com.mongodb.reactivestreams.client.MongoClient
import com.acn.dlt.corda.doorman.storage.mongo.IndexType.HASHED
import net.corda.core.node.NotaryInfo
import net.corda.core.node.services.AttachmentId

class StagedParameterUpdateStorage(
  private val client: MongoClient,
  private val dbName: String,
  private val collectionName: String = DEFAULT_COLLECTION
) {
  companion object {
    val DEFAULT_COLLECTION = "staged-parameter-update"
  }

  private val collection = client.getDatabase(dbName).getCollection(collectionName)

  init {
    collection.createIndex(HASHED idx StagedNetworkParameterUpdate::name)
  }
}

data class StagedNetworkParameterUpdate(val name: String,
                                        val notaries: List<NotaryInfo>,
                                        val whitelist: Map<String, List<AttachmentId>>)