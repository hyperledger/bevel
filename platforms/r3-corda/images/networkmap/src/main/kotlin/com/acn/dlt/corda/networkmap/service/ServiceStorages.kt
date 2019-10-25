package com.acn.dlt.corda.networkmap.service

import com.mongodb.reactivestreams.client.MongoClient
import io.bluebank.braid.core.logging.loggerFor
import com.acn.dlt.corda.networkmap.storage.file.NetworkParameterInputsStorage
import com.acn.dlt.corda.networkmap.storage.file.TextStorage
import com.acn.dlt.corda.networkmap.storage.mongo.*
import com.acn.dlt.corda.networkmap.utils.all
import com.acn.dlt.corda.networkmap.utils.catch
import com.acn.dlt.corda.networkmap.utils.mapUnit
import com.acn.dlt.corda.networkmap.utils.sign
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
    private val logger = loggerFor<ServiceStorages>()
    const val CURRENT_PARAMETERS = "current-parameters" // key for current network parameters hash
    const val NEXT_PARAMS_UPDATE = "next-params-update" // key for next params update hash
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
      networkParameters.migrate(com.acn.dlt.corda.networkmap.storage.file.SignedNetworkParametersStorage(vertx, dbDirectory)),
      parameterUpdate.migrate(com.acn.dlt.corda.networkmap.storage.file.ParametersUpdateStorage(vertx, dbDirectory)),
      // TODO: add something to clear down cached networkmaps on the filesystem from previous versions
      text.migrate(TextStorage(vertx, dbDirectory)),
      nodeInfo.migrate(com.acn.dlt.corda.networkmap.storage.file.SignedNodeInfoStorage(vertx, dbDirectory)),
      certAndKeys.migrate(com.acn.dlt.corda.networkmap.storage.file.CertificateAndKeyPairStorage(vertx, dbDirectory))
    ).mapUnit()
  }

  fun getCurrentNetworkParametersHash() : Future<SecureHash> {
    return text.get(CURRENT_PARAMETERS)
      .map { SecureHash.parse(it) as SecureHash }
      .catch { err ->
        logger.error("failed to get current networkparameters hash", err)
      }
  }

  fun getNetworkParameters(hash: SecureHash) : Future<NetworkParameters> {
    return networkParameters.get(hash.toString()).map { it.verified() }
  }

  fun getCurrentNetworkParameters() : Future<NetworkParameters> {
    return getCurrentSignedNetworkParameters().map { it.verified() }
      .catch { err ->
        logger.error("failed to get current network parameters", err)
      }
  }

  fun getCurrentSignedNetworkParameters() : Future<SignedNetworkParameters> {
    return text.get(CURRENT_PARAMETERS).compose { key -> networkParameters.get(key) }
      .catch { err ->
        logger.error("failed to get current signed network parameters", err)
      }
  }

  fun storeCurrentParametersHash(hash: SecureHash) : Future<SecureHash> {
    logger.info("storing current network parameters $hash")
    return text.put(CURRENT_PARAMETERS, hash.toString()).map { hash }
  }

  fun storeNextParametersUpdate(parametersUpdate: ParametersUpdate) : Future<Unit> {
    logger.info("storing next parameter update $parametersUpdate")
    return parameterUpdate.put(NEXT_PARAMS_UPDATE, parametersUpdate)
  }

  fun resetNextParametersUpdate() : Future<Unit> {
    logger.info("resetting next parameter update")
    return parameterUpdate.delete(NEXT_PARAMS_UPDATE)
  }

  fun getParameterUpdateOrNull() : Future<ParametersUpdate?> {
    return parameterUpdate.getOrNull(NEXT_PARAMS_UPDATE)
  }

  fun storeNetworkParameters(newParams: NetworkParameters, certs: CertificateAndKeyPair) : Future<SecureHash> {
    val signed = newParams.sign(certs)
    val hash = signed.raw.hash
    logger.info("storing network parameters $hash with values $newParams")
    return networkParameters.put(hash.toString(), signed).map { hash }
  }

}