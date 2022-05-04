@file:Suppress("DEPRECATION")

package com.acn.dlt.corda.networkmap.service

import io.bluebank.braid.core.async.mapUnit
import com.acn.dlt.corda.networkmap.changeset.Change
import com.acn.dlt.corda.networkmap.changeset.changeSet
import com.acn.dlt.corda.networkmap.serialisation.NetworkParametersMixin
import com.acn.dlt.corda.networkmap.serialisation.deserializeOnContext
import com.acn.dlt.corda.networkmap.serialisation.parseWhitelist
import com.acn.dlt.corda.networkmap.service.NetworkMapService.Companion.ADMIN_REST_ROOT
import com.acn.dlt.corda.networkmap.utils.*
import io.netty.handler.codec.http.HttpHeaderNames
import io.netty.handler.codec.http.HttpHeaderValues
import io.swagger.annotations.ApiOperation
import io.swagger.annotations.ApiParam
import io.swagger.annotations.ApiResponse
import io.swagger.annotations.ApiResponses
import io.vertx.core.Future
import io.vertx.core.Future.failedFuture
import io.vertx.core.Future.succeededFuture
import io.vertx.core.Vertx
import io.vertx.core.buffer.Buffer
import io.vertx.core.json.Json
import io.vertx.ext.web.RoutingContext
import net.corda.core.crypto.SecureHash
import net.corda.core.crypto.sha256
import net.corda.core.internal.CertRole
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
  vertx: Vertx,
  private val storages: ServiceStorages,
  private val certificateManager: CertificateManager,
  val paramUpdateDelay: Duration,
  private val allowNodeKeyChange: Boolean
) {
  companion object {
    private val logger = loggerFor<NetworkMapServiceProcessor>()
    const val EXECUTOR = "network-map-pool"

    private val templateNetworkParameters = NetworkParameters(
      minimumPlatformVersion = 4,
      notaries = listOf(),
      maxMessageSize = 10485760,
      maxTransactionSize = Int.MAX_VALUE,
      modifiedTime = Instant.now(),
      epoch = 1, // this will be incremented when used for the first time
      whitelistedContractImplementations = mapOf()
    )
  }

  // we use a single thread to queue changes to the map, to ensure consistency
  private val executor = vertx.createSharedWorkerExecutor(EXECUTOR, 1)
  private lateinit var certs: CertificateAndKeyPair

  fun start(networkParameters: NetworkParameters): Future<Unit> {
    certs = certificateManager.networkMapCertAndKeyPair
    return execute { createNetworkParameters(networkParameters).mapUnit() }
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
          if(!allowNodeKeyChange) {
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
              val msg = "node failed to register because the following names have already been registered with different public keys $names"
              logger.warn(msg)
              throw RuntimeException(msg)
            }
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

  // BEGIN: web entry points

  @Suppress("MemberVisibilityCanBePrivate")
  @ApiOperation(value = """For the non validating notary to upload its signed NodeInfo object to the network map",
    Please ignore the way swagger presents this. To upload a notary info file use:
      <code>
      curl -X POST -H "Authorization: Bearer &lt;token&gt;" -H "accept: text/plain" -H  "Content-Type: application/octet-stream" --data-binary @nodeInfo-007A0CAE8EECC5C9BE40337C8303F39D34592AA481F3153B0E16524BAD467533 http://localhost:8080//admin/api/notaries/nonValidating
      </code>
      """,
    consumes = MediaType.APPLICATION_OCTET_STREAM
  )
  fun postNonValidatingNotaryNodeInfo(nodeInfoBuffer: Buffer): Future<String> {
      return processNotaryNodeInfo(nodeInfoBuffer, false)
  }

  @Suppress("MemberVisibilityCanBePrivate")
  @ApiOperation(value = """For the validating notary to upload its signed NodeInfo object to the network map.
    Please ignore the way swagger presents this. To upload a notary info file use:
      <code>
      curl -X POST -H "Authorization: Bearer &lt;token&gt;" -H "accept: text/plain" -H  "Content-Type: application/octet-stream" --data-binary @nodeInfo-007A0CAE8EECC5C9BE40337C8303F39D34592AA481F3153B0E16524BAD467533 http://localhost:8080//admin/api/notaries/validating
      </code>
      """,
    consumes = MediaType.APPLICATION_OCTET_STREAM
  )
  fun postValidatingNotaryNodeInfo(nodeInfoBuffer: Buffer): Future<String> {
    return processNotaryNodeInfo(nodeInfoBuffer, true)
  }

  fun processNotaryNodeInfo(nodeInfoBuffer: Buffer, validating: Boolean) : Future<String> {
    val notaryType = if (validating) {
      "validating"
    } else {
      "non-validating"
    }
    return try {
      logger.info("adding $notaryType notary")
      val nodeInfo = nodeInfoBuffer.bytes.deserializeOnContext<SignedNodeInfo>().verified()
      val notary = nodeInfo.legalIdentitiesAndCerts
        .firstOrNull { CertRole.extract(it.certificate) == CertRole.SERVICE_IDENTITY }?.party
        ?: nodeInfo.legalIdentities.first()
      val notaryInfo = NotaryInfo(notary, validating)
      addNotaryInfo(notaryInfo)
    } catch (err: Throwable) {
      logger.error("failed to add $notaryType notary", err)
      failedFuture(err)
    }
  }

  private fun addNotaryInfo(notaryInfo: NotaryInfo): Future<String> {
    return addNotaryInfos(listOf(notaryInfo))
  }

  internal fun addNotaryInfos(notaryInfos: List<NotaryInfo>): Future<String> {
    val updater = changeSet(notaryInfos.map { Change.AddNotary(it) })
    return updateNetworkParameters(updater, "admin adding notaries $notaryInfos").map { "OK" }
  }

  @ApiOperation(value = "append to the whitelist")
  fun appendWhitelist(append: String): Future<Unit> {
    logger.info("appending to whitelist:\n$append")
    return try {
      logger.info("web request to append to whitelist $append")
      val parsed = append.parseWhitelist()
      val updater = changeSet(Change.AppendWhiteList(parsed))
      updateNetworkParameters(updater, "admin appending to the whitelist")
        .onSuccess {
          logger.info("completed append to whitelist")
        }
        .catch {
          logger.error("failed to append to whitelist")
        }
        .mapUnit()
    } catch (err: Throwable) {
      failedFuture(err)
    }
  }

  @ApiOperation(value = "replace the whitelist")
  fun replaceWhitelist(replacement: String): Future<Unit> {
    logger.info("replacing current whitelist with: \n$replacement")
    return try {
      val parsed = replacement.parseWhitelist()
      val updater = changeSet(Change.ReplaceWhiteList(parsed))
      updateNetworkParameters(updater, "admin replacing the whitelist").mapUnit()
    } catch (err: Throwable) {
      failedFuture(err)
    }
  }


  @ApiOperation(value = "clears the whitelist")
  fun clearWhitelist(): Future<Unit> {
    logger.info("clearing current whitelist")
    return try {
      val updater = changeSet(Change.ClearWhiteList)
      updateNetworkParameters(updater, "admin clearing the whitelist").mapUnit()
    } catch (err: Throwable) {
      failedFuture(err)
    }
  }

  @ApiOperation(value = "serve whitelist", response = String::class)
  fun serveWhitelist(routingContext: RoutingContext) {
    logger.trace("serving current whitelist")
    createNetworkMap()
      .compose { storages.getNetworkParameters(it.networkParameterHash) }
      .map {
        it.whitelistedContractImplementations
          .flatMap { entry ->
            entry.value.map { attachmentId ->
              "${entry.key}:$attachmentId"
            }
          }.joinToString("\n")
      }
      .onSuccess { whitelist ->
        routingContext.response()
          .setNoCache().putHeader(HttpHeaderNames.CONTENT_TYPE, HttpHeaderValues.TEXT_PLAIN).end(whitelist)
      }
      .catch { routingContext.setNoCache().end(it) }
  }

  @Suppress("MemberVisibilityCanBePrivate")
  @ApiOperation(value = "delete a validating notary with the node key")
  fun deleteValidatingNotary(nodeKey: String): Future<Unit> {
    logger.info("deleting validating notary $nodeKey")
    return try {
      val nameHash = SecureHash.parse(nodeKey)
      updateNetworkParameters(changeSet(Change.RemoveNotary(nameHash)), "admin deleting validating notary").mapUnit()
    } catch (err: Throwable) {
      failedFuture(err)
    }
  }

  @Suppress("MemberVisibilityCanBePrivate")
  @ApiOperation(value = "delete a non-validating notary with the node key")
  fun deleteNonValidatingNotary(nodeKey: String): Future<Unit> {
    logger.info("deleting non-validating notary $nodeKey")
    return try {
      val nameHash = SecureHash.parse(nodeKey)
      updateNetworkParameters(changeSet(Change.RemoveNotary(nameHash)), "admin deleting non-validating notary").mapUnit()
    } catch (err: Throwable) {
      failedFuture(err)
    }
  }

  @Suppress("MemberVisibilityCanBePrivate")
  @ApiOperation(value = "delete a node by its key")
  fun deleteNode(nodeKey: String): Future<Unit> {
    logger.info("deleting node $nodeKey")
    return storages.nodeInfo.delete(nodeKey)
  }

  @Suppress("MemberVisibilityCanBePrivate")
  @ApiOperation(value = "delete all nodeinfos")
  fun deleteAllNodes(): Future<Unit> {
    logger.info("deleting all nodeinfos")
    return try {
      storages.nodeInfo.clear()
    } catch (err: Throwable) {
      failedFuture(err)
    }
  }

  @ApiOperation(value = "serve set of notaries", response = SimpleNotaryInfo::class, responseContainer = "List")
  fun serveNotaries(routingContext: RoutingContext) {
    logger.trace("serving current notaries")
    createNetworkMap()
      .compose { storages.getNetworkParameters(it.networkParameterHash) }
      .map { networkParameters ->
        networkParameters.notaries.map {
          SimpleNotaryInfo(it.identity.name.serialize().hash.toString(), it)
        }
      }
      .onSuccess { simpleNodeInfos ->
        routingContext.setNoCache().end(simpleNodeInfos)
      }
      .catch {
        routingContext.setNoCache().end(it)
      }
  }

  @ApiOperation(value = "serve a page of network parameters", response = NetworkParameters::class, responseContainer = "Map")
  fun getAllNetworkParameters(@ApiParam(name = "pageSize", value = "the page size", defaultValue = "10")
                              @QueryParam("pageSize")
                              pageSize: Int,
                              @ApiParam(name = "page", value = "the page to load", defaultValue = "1")
                              @QueryParam("page")
                              page: Int): Future<Map<String, NetworkParameters>> {
    assert(page > 0) { "page should be 1 or greater - received $page" }
    assert(pageSize > 0) { "pageSize should 1 or greater - received $page" }
    return storages.networkParameters.getKeys().map {
      it.drop((page - 1) * pageSize)
    }.compose { storages.networkParameters.getAll(it) }
      .map { networkParams -> networkParams.mapValues { entry -> entry.value.verified() } }
  }

  @ApiOperation(value = "replace current network map", response = String::class)
  fun replaceAllNetworkParameters(networkParametersMixin: NetworkParametersMixin): Future<String> {
    logger.info("replacing all network parameters")
    return try {
      val newNetworkParameters = Json.mapper.convertValue(networkParametersMixin, NetworkParameters::class.java)
      val updater = changeSet(Change.ReplaceAllNetworkParameters(newNetworkParameters))
      updateNetworkParameters(updater, "admin replacing all network parameters").map { "OK" }
    } catch (err: Throwable) {
      logger.error("failed to replace the network parameters", err)
      failedFuture(err)
    }
  }

  @ApiOperation(value = "serve current network map as a JSON document", response = NetworkMap::class)
  fun getCurrentNetworkMap(): Future<NetworkMap> {
    return createNetworkMap()
  }

  @Suppress("MemberVisibilityCanBePrivate")
  @ApiOperation(value = "retrieve all nodeinfos", responseContainer = "List", response = SimpleNodeInfo::class)
  fun serveNodes(context: RoutingContext) {
    logger.info("serving current set of node")
    context.setNoCache()
    storages.nodeInfo.getAll()
      .onSuccess { mapOfNodes ->
        context.end(mapOfNodes.map { namedNodeInfo ->
          val node = namedNodeInfo.value.verified()
          SimpleNodeInfo(
            nodeKey = namedNodeInfo.key,
            addresses = node.addresses,
            parties = node.legalIdentitiesAndCerts.map { NameAndKey(it.name, it.owningKey) },
            platformVersion = node.platformVersion
          )
        })
      }
      .catch { context.end(it) }
  }

  @Suppress("MemberVisibilityCanBePrivate")
  @ApiOperation(value = "retrieve nodeinfos size and total number of pages", response = NodeInfoPagingSummary::class)
  @ApiResponses(
    value = [
      ApiResponse(code = 200, message = "OK"),
      ApiResponse(code = 400, message = "pageSize should be greater than zero"),
      ApiResponse(code = 500, message = "Internal server error")
    ]
  )
  fun nodeInfoPagingSummary(@ApiParam(
    name="pageSize",
    required = false,
    defaultValue = "10",
    value = "page size - must be greater than zero"
  ) pageSize: Int = 10): Future<NodeInfoPagingSummary> {
    logger.info("retrieving the paging summary of nodeInfos")
    check(pageSize > 0) { "pageSize should be greater than zero" }
    return storages.nodeInfo.size()
      .map { size ->
        NodeInfoPagingSummary(
          size,
          size.div(pageSize),
          pageSize
        )
      }
  }

  @ApiOperation(value = "serve a page of node Infos", response = NodeInfosByPage::class)
  @ApiResponses(
    value = [
      ApiResponse(code = 200, message = "OK"),
      ApiResponse(code = 400, message = "pageSize should be greater than zero"),
      ApiResponse(code = 400, message = "page should be greater than zero"),
      ApiResponse(code = 404, message = "requested page should be lesser than total pages"),
      ApiResponse(code = 500, message = "Internal server error")
    ]
  )
  fun getNodeInfoByPage(@ApiParam(defaultValue = "1", name="page", required = true, value = "page number - must be greater than 0")
                        @QueryParam("page") page: Int,
                        @ApiParam(defaultValue = "10", name="pageSize", required = true, value = "page size - must be greater than zero")
                        @QueryParam("pageSize") pageSize: Int): Future<NodeInfosByPage> {
    var nextPageUrl: String? = null
    check(pageSize > 0) { "pageSize should be greater than zero" }
    check(page > 0) { "page should be greater than zero" }
    return storages.nodeInfo.size()
      .onSuccess {
        assert(it != 0) { "Error while getting total number of nodes" }
        val totalPages = it / pageSize
        assert(page <= totalPages) { "requested page should be lesser than total pages" }
        nextPageUrl = if (page < totalPages) "$ADMIN_REST_ROOT/nodes/page?pageSize=$pageSize&page=${page + 1}" else null
      }
      .compose {
        storages.nodeInfo.getPage(page, pageSize)
      }
      .map { mapOfNodes ->
        val simpleNodeInfos = mapOfNodes.map { namedNodeInfo ->
          val node = namedNodeInfo.value.verified()
          SimpleNodeInfo(
            nodeKey = namedNodeInfo.key,
            addresses = node.addresses,
            parties = node.legalIdentitiesAndCerts.map { NameAndKey(it.name, it.owningKey) },
            platformVersion = node.platformVersion
          )
        }
        NodeInfosByPage(
          simpleNodeInfos,
          nextPageUrl
        )
      }
  }

  @Suppress("MemberVisibilityCanBePrivate")
  @ApiOperation(value = "Retrieve the current network parameters",
    produces = MediaType.APPLICATION_JSON, response = NetworkParameters::class)
  fun getCurrentNetworkParameters(context: RoutingContext) {
    logger.trace("serving current network parameters")
    createNetworkMap().compose { storages.getNetworkParameters(it.networkParameterHash) }
    storages.getCurrentNetworkParameters()
      .onSuccess { context.end(it) }
      .catch { context.end(it) }
  }

  // END: web entry points

  // BEGIN: core functions

  internal fun updateNetworkParameters(update: (NetworkParameters) -> NetworkParameters, description: String = ""): Future<Unit> {
    return updateNetworkParameters(update, description, Instant.now().plus(paramUpdateDelay))
  }

  private fun createNetworkParameters(networkParameters: NetworkParameters): Future<SecureHash> {
    logger.info("creating network parameters ...")
    logger.info("retrieving current network parameter ...")
    return storages.getCurrentSignedNetworkParameters().map { it.raw.hash }
      .recover {
        logger.info("could not find network parameters - creating one from the template")
        storages.storeNetworkParameters(networkParameters, certs)
          .compose { hash -> storages.storeCurrentParametersHash(hash) }
          .onSuccess { result ->
            logger.info("network parameters saved $result")
          }
          .catch { err ->
            logger.info("failed to create network parameters", err)
          }
      }
  }

  internal fun updateNetworkParameters(changeFunction: (NetworkParameters) -> NetworkParameters, description: String, activation: Instant): Future<Unit> {
    return execute {
      logger.info("updating network parameters")
      // we need a base version of the network parameters to apply our changes to
      // the following mechanism is frankly not safe until
      // a. we have formally named changesets
      // b. we add routines for pessimistic locking

      // never the less, we do our best - this should be sufficient for a single node network map service
      // do we have a scheduled network map update?
      storages.getParameterUpdateOrNull()
        .compose { update ->
          when (update) {
            null -> storages.getCurrentNetworkParameters()
            else -> storages.getNetworkParameters(update.newParametersHash)
          }
        }
        .map { changeFunction(it) } // apply changeset and sign
        .compose { newNetworkParameters ->
          storages.storeNetworkParameters(newNetworkParameters, certs)
        }
        .compose { hash ->
          if (activation <= Instant.now()) {
            storages.storeCurrentParametersHash(hash).mapUnit()
          } else {
            storages.storeNextParametersUpdate(ParametersUpdate(hash, description, activation))
          }
        }
    }
  }

  fun createSignedNetworkMap(): Future<SignedNetworkMap> {
    return createNetworkMap().map { nm -> nm.sign(certs) }
  }

  private fun createNetworkMap(): Future<NetworkMap> {
    val fNodes = storages.nodeInfo.getKeys().map { keys -> keys.map { key -> SecureHash.parse(key) } }
    val fParamUpdate = storages.getParameterUpdateOrNull()
    val fLatestParamHash = storages.getCurrentNetworkParametersHash()
      .catch {
        logger.error("failed to ")
      }
    // when all collected
    return all(fNodes, fParamUpdate, fLatestParamHash)
      .map {
        val nodes = fNodes.result()
        val paramUpdate = fParamUpdate.result()
        val latestParamHash = fLatestParamHash.result()

        NetworkMap(
          networkParameterHash = latestParamHash,
          parametersUpdate = paramUpdate,
          nodeInfoHashes = nodes
        )
      }.compose { nm ->
        logger.trace("base for network-map is: $nm")
        val now = Instant.now()
        when {
          nm.parametersUpdate != null && (now >= nm.parametersUpdate!!.updateDeadline) -> {
            logger.trace("applying network parameters update ${nm.parametersUpdate!!.newParametersHash}")
            storages.storeCurrentParametersHash(nm.parametersUpdate!!.newParametersHash)
              .compose {
                storages.resetNextParametersUpdate().map {
                  nm.copy(
                    networkParameterHash = nm.parametersUpdate!!.newParametersHash,
                    parametersUpdate = null)
                }
              }
          }
          nm.parametersUpdate != null && (now < nm.parametersUpdate!!.updateDeadline) -> {
            logger.trace("parameter update is in the future - using the base nm")
            succeededFuture(nm)
          }
          else -> {
            logger.trace("no network update")
            succeededFuture(nm)
          }
        }
      }
  }

  // END: core functions

  // BEGIN: utility functions

  /**
   * Execute a blocking operation on a non-eventloop thread
   */
  private fun <T> execute(fn: () -> Future<T>): Future<T> {
    return withFuture { result ->
      executor.executeBlocking<T>({
        fn().setHandler(it.completer())
      }, {
        result.handle(it)
      })
    }
  }
  // END: utility functions
}

data class NodeInfoPagingSummary(val totalNoOfNodeInfos: Int, val totalPages: Int, val pageSize: Int)
data class NodeInfosByPage(val simpleNodeInfos: List<SimpleNodeInfo>, val nextPage: String?)