package com.acn.dlt.corda.networkmap.storage.mongo

import io.bluebank.braid.core.async.mapUnit
import com.acn.dlt.corda.networkmap.service.ServiceStorages
import com.acn.dlt.corda.networkmap.service.StorageType
import com.acn.dlt.corda.networkmap.storage.Storage
import com.acn.dlt.corda.networkmap.storage.file.TextStorage
import com.acn.dlt.corda.networkmap.utils.NMSOptions
import com.acn.dlt.corda.networkmap.utils.all
import io.vertx.core.Future
import io.vertx.core.Vertx
import net.corda.core.crypto.SecureHash

class MongoServiceStorages(private val vertx: Vertx, private val nmsOptions: NMSOptions) : ServiceStorages() {
  init {
    assert(nmsOptions.storageType == StorageType.MONGO) { "mongo service cannot be initiated with storage type set to ${nmsOptions.storageType}"}
  }

  private val mongoClient = MongoStorage.connect(nmsOptions)
  override val certAndKeys = CertificateAndKeyPairStorage(mongoClient, nmsOptions.mongodDatabase)
  override val nodeInfo = SignedNodeInfoStorage(mongoClient, nmsOptions.mongodDatabase)
  override val networkParameters = SignedNetworkParametersStorage(mongoClient, nmsOptions.mongodDatabase)
  override val parameterUpdate  = ParametersUpdateStorage(mongoClient, nmsOptions.mongodDatabase)
  override val text  = MongoTextStorage(mongoClient, nmsOptions.mongodDatabase)
  override val latestAcceptedParameters = SecureHashStorage(mongoClient, nmsOptions.mongodDatabase)

  override fun setupStorage(): Future<Unit> {
    return all(
      networkParameters.migrate(com.acn.dlt.corda.networkmap.storage.file.SignedNetworkParametersStorage(vertx, nmsOptions.dbDirectory)),
      parameterUpdate.migrate(com.acn.dlt.corda.networkmap.storage.file.ParametersUpdateStorage(vertx, nmsOptions.dbDirectory)),
      // TODO: add something to clear down cached networkmaps on the filesystem from previous versions
      text.migrate(TextStorage(vertx, nmsOptions.dbDirectory)),
      nodeInfo.migrate(com.acn.dlt.corda.networkmap.storage.file.SignedNodeInfoStorage(vertx, nmsOptions.dbDirectory)),
      certAndKeys.migrate(com.acn.dlt.corda.networkmap.storage.file.CertificateAndKeyPairStorage(vertx, nmsOptions.dbDirectory)),
      latestAcceptedParameters.migrate(com.acn.dlt.corda.networkmap.storage.file.SecureHashStorage(vertx, nmsOptions.dbDirectory))
    ).mapUnit()
  }
}