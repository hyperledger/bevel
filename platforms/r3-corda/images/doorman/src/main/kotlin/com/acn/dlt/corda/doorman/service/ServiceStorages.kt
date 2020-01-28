package com.acn.dlt.corda.doorman.service

import com.mongodb.reactivestreams.client.MongoClient
import io.bluebank.braid.core.logging.loggerFor
import com.acn.dlt.corda.doorman.storage.file.NetworkParameterInputsStorage
import com.acn.dlt.corda.doorman.storage.file.TextStorage
import com.acn.dlt.corda.doorman.storage.mongo.*
import com.acn.dlt.corda.doorman.utils.all
import com.acn.dlt.corda.doorman.utils.catch
import com.acn.dlt.corda.doorman.utils.mapUnit
import com.acn.dlt.corda.doorman.utils.sign
import io.vertx.core.Future
import io.vertx.core.Vertx
import net.corda.core.crypto.SecureHash
import net.corda.core.node.NetworkParameters
import net.corda.nodeapi.internal.crypto.CertificateAndKeyPair
import net.corda.nodeapi.internal.network.ParametersUpdate
import net.corda.nodeapi.internal.network.SignedNetworkParameters
import java.io.File

class ServiceStorages(
  private val vertx: Vertx,
  private val dbDirectory: File,
  mongoClient: MongoClient,
  mongoDatabase: String
) {
  companion object {
  }

  val certAndKeys = CertificateAndKeyPairStorage(mongoClient, mongoDatabase)
  val input = NetworkParameterInputsStorage(dbDirectory, vertx)
  val nodeInfo = SignedNodeInfoStorage(mongoClient, mongoDatabase)
  val networkParameters = SignedNetworkParametersStorage(mongoClient, mongoDatabase)
  private val parameterUpdate = ParametersUpdateStorage(mongoClient, mongoDatabase)
  val text = MongoTextStorage(mongoClient, mongoDatabase)

  fun setupStorage(): Future<Unit> {
    return all(
      input.makeDirs(),
      networkParameters.migrate(com.acn.dlt.corda.doorman.storage.file.SignedNetworkParametersStorage(vertx, dbDirectory)),
      parameterUpdate.migrate(com.acn.dlt.corda.doorman.storage.file.ParametersUpdateStorage(vertx, dbDirectory)),
      // TODO: add something to clear down cached networkmaps on the filesystem from previous versions
      text.migrate(TextStorage(vertx, dbDirectory)),
      nodeInfo.migrate(com.acn.dlt.corda.doorman.storage.file.SignedNodeInfoStorage(vertx, dbDirectory)),
      certAndKeys.migrate(com.acn.dlt.corda.doorman.storage.file.CertificateAndKeyPairStorage(vertx, dbDirectory))
    ).mapUnit()
  }
}