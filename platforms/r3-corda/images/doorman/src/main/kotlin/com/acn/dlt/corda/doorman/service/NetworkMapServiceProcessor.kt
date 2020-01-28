@file:Suppress("DEPRECATION")

package com.acn.dlt.corda.doorman.service

import com.acn.dlt.corda.doorman.changeset.Change
import com.acn.dlt.corda.doorman.changeset.changeSet
import com.acn.dlt.corda.doorman.serialisation.deserializeOnContext
import com.acn.dlt.corda.doorman.utils.*
import io.netty.handler.codec.http.HttpHeaderNames
import io.netty.handler.codec.http.HttpHeaderValues
import io.swagger.annotations.ApiOperation
import io.swagger.annotations.ApiParam
import io.vertx.core.Future
import io.vertx.core.Future.failedFuture
import io.vertx.core.Future.succeededFuture
import io.vertx.core.Vertx
import io.vertx.core.buffer.Buffer
import io.vertx.ext.web.RoutingContext
import net.corda.core.crypto.SecureHash
import net.corda.core.crypto.sha256
import net.corda.core.node.NetworkParameters
import net.corda.core.node.NotaryInfo
import net.corda.core.serialization.serialize
import net.corda.core.utilities.loggerFor
import net.corda.nodeapi.internal.SignedNodeInfo
import net.corda.nodeapi.internal.crypto.CertificateAndKeyPair
import net.corda.nodeapi.internal.network.NetworkMap
import net.corda.nodeapi.internal.network.ParametersUpdate
import net.corda.nodeapi.internal.network.SignedNetworkMap
import java.time.Duration
import java.time.Instant
import javax.ws.rs.QueryParam
import javax.ws.rs.core.MediaType

/**
 * Event processor for the network map
 * This consumes networkparameter inputs changes; and nodeinfo updates
 * and rebuilds the set of files to be served by the server
 */
class NetworkMapServiceProcessor(
  private val storages: ServiceStorages
) {
  companion object {
    private val logger = loggerFor<NetworkMapServiceProcessor>()
  }

  fun stop() {}

  fun addNode(signedNodeInfo: SignedNodeInfo): Future<Unit> {
    try {
      logger.info("adding signed nodeinfo ${signedNodeInfo.raw.hash}")
      val ni = signedNodeInfo.verified()
      val partyAndCerts = ni.legalIdentitiesAndCerts

      // TODO: optimise this to use the database, and avoid loading all nodes into memory

      return storages.nodeInfo.getAll()
        .onSuccess { nodes ->
          // flatten the current nodes to Party -> PublicKey map
          val registered = nodes.flatMap { namedSignedNodeInfo ->
            namedSignedNodeInfo.value.verified().legalIdentitiesAndCerts.map { partyAndCertificate ->
              partyAndCertificate.party.name to partyAndCertificate.owningKey
            }
          }.toMap()

          // now filter the party and certs of the nodeinfo we're trying to register
          val registeredWithDifferentKey = partyAndCerts.filter {
            // looking for where the public keys differ
            registered[it.party.name].let { pk ->
              pk != null && pk != it.owningKey
            }
          }
          if (registeredWithDifferentKey.any()) {
            val names = registeredWithDifferentKey.joinToString("\n") { it.name.toString() }
            val msg = "node failed to registered because the following names have already been registered with different public keys $names"
            logger.warn(msg)
            throw RuntimeException(msg)
          }
        }
        .compose {
          val hash = signedNodeInfo.raw.sha256()
          storages.nodeInfo.put(hash.toString(), signedNodeInfo)
            .onSuccess { logger.info("node ${signedNodeInfo.raw.hash} for party ${ni.legalIdentities} added") }
        }
        .catch { ex ->
          logger.error("failed to add node", ex)
        }
    } catch (err: Throwable) {
      logger.error("failed to add node", err)
      return failedFuture(err)
    }
  }
}