package com.acn.dlt.corda.networkmap.service

import io.bluebank.braid.core.logging.loggerFor
import com.acn.dlt.corda.networkmap.storage.Storage
import com.acn.dlt.corda.networkmap.storage.file.FileServiceStorages
import com.acn.dlt.corda.networkmap.storage.mongo.MongoServiceStorages
import com.acn.dlt.corda.networkmap.utils.NMSOptions
import com.acn.dlt.corda.networkmap.utils.catch
import com.acn.dlt.corda.networkmap.utils.sign
import io.vertx.core.Future
import io.vertx.core.Vertx
import net.corda.core.crypto.SecureHash
import net.corda.core.crypto.SignedData
import net.corda.core.node.NetworkParameters
import net.corda.nodeapi.internal.SignedNodeInfo
import net.corda.nodeapi.internal.crypto.CertificateAndKeyPair
import net.corda.nodeapi.internal.network.ParametersUpdate
import net.corda.nodeapi.internal.network.SignedNetworkParameters
import java.security.PublicKey

enum class StorageType {
  FILE,
  MONGO
}

abstract class ServiceStorages {
  companion object {

    fun create(vertx: Vertx, nmsOptions: NMSOptions) : ServiceStorages {
      return when (nmsOptions.storageType) {
        StorageType.FILE -> FileServiceStorages(vertx, nmsOptions)
        StorageType.MONGO -> MongoServiceStorages(vertx, nmsOptions)
      }
    }
    private val logger = loggerFor<ServiceStorages>()
    const val CURRENT_PARAMETERS = "current-parameters" // key for current network parameters hash
    const val NEXT_PARAMS_UPDATE = "next-params-update" // key for next params update hash
  }

  abstract val certAndKeys : Storage<CertificateAndKeyPair>
  abstract val nodeInfo : Storage<SignedNodeInfo>
  abstract val networkParameters : Storage<SignedNetworkParameters>
  protected abstract val parameterUpdate : Storage<ParametersUpdate>
  abstract val text : Storage<String>
  abstract val latestAcceptedParameters : Storage<SecureHash>

  abstract fun setupStorage(): Future<Unit>

  fun getCurrentNetworkParametersHash(): Future<SecureHash> {
    return text.get(CURRENT_PARAMETERS)
      .map { SecureHash.parse(it) as SecureHash }
      .catch { err ->
        logger.error("failed to get current networkparameters hash", err)
      }
  }

  fun getNetworkParameters(hash: SecureHash): Future<NetworkParameters> {
    return networkParameters.get(hash.toString()).map { it.verified() }
  }

  fun getCurrentNetworkParameters(): Future<NetworkParameters> {
    return getCurrentSignedNetworkParameters().map { it.verified() }
      .catch { err ->
        logger.error("failed to get current network parameters", err)
      }
  }

  fun getCurrentSignedNetworkParameters(): Future<SignedNetworkParameters> {
    return text.get(CURRENT_PARAMETERS).compose { key -> networkParameters.get(key) }
      .catch { err ->
        logger.error("failed to get current signed network parameters", err)
      }
  }

  fun storeCurrentParametersHash(hash: SecureHash): Future<SecureHash> {
    logger.info("storing current network parameters $hash")
    return text.put(CURRENT_PARAMETERS, hash.toString()).map { hash }
  }

  fun storeNextParametersUpdate(parametersUpdate: ParametersUpdate): Future<Unit> {
    logger.info("storing next parameter update $parametersUpdate")
    return parameterUpdate.put(NEXT_PARAMS_UPDATE, parametersUpdate)
  }

  fun resetNextParametersUpdate(): Future<Unit> {
    logger.info("resetting next parameter update")
    return parameterUpdate.delete(NEXT_PARAMS_UPDATE)
  }

  fun getParameterUpdateOrNull(): Future<ParametersUpdate?> {
    return parameterUpdate.getOrNull(NEXT_PARAMS_UPDATE)
  }

  fun storeNetworkParameters(newParams: NetworkParameters, certs: CertificateAndKeyPair): Future<SecureHash> {
    val signed = newParams.sign(certs)
    val hash = signed.raw.hash
    logger.info("storing network parameters $hash with values $newParams")
    return networkParameters.put(hash.toString(), signed).map { hash }
  }
  
  fun storeLatestParametersAccepted(signedParameterHash: SignedData<SecureHash>): Future<SecureHash> {
    val hash: SecureHash = signedParameterHash.verified()
    return latestAcceptedParameters.put(signedParameterHash.sig.by.toString(), hash).map { hash }
  }
  
  fun latestParametersAccepted(publicKey: PublicKey): Future<SecureHash> {
    return latestAcceptedParameters.get(publicKey.toString())
  }
}