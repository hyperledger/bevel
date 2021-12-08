package com.supplychain.bcc.webserver

import com.supplychain.bcc.contractstates.ContainerState
import com.supplychain.bevel.*
import net.corda.client.jackson.JacksonSupport
import net.corda.core.messaging.vaultQueryBy
import net.corda.core.node.services.vault.DEFAULT_PAGE_NUM
import net.corda.core.node.services.vault.PageSpecification
import net.corda.core.node.services.vault.QueryCriteria
import net.corda.core.utilities.getOrThrow
import org.slf4j.LoggerFactory
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.util.*


@RestController
@RequestMapping("/api/v1/container")
class ContainerController(rpc: NodeRPCConnection) {

    companion object {
        private val logger = LoggerFactory.getLogger(RestController::class.java)
    }

    private val proxy = rpc.proxy
    private val mapper = JacksonSupport.createDefaultMapper(proxy)



    private fun multiplePageGetContainers(): String? {
        var pageNumber = DEFAULT_PAGE_NUM
        val states = mutableListOf<ContainerState>()

        do{
            var pageSpec = PageSpecification(pageNumber = pageNumber, pageSize = 200)
            var rawResults = proxy.vaultQueryBy<ContainerState>(QueryCriteria.VaultQueryCriteria(),pageSpec)
            var results = rawResults.states.map { it.state.data }
            states.addAll(results)
            pageNumber++
            //mapper.writeValueAsString(proxy.vaultQueryBy<ContainerState>( QueryCriteria.VaultQueryCriteria(Vault.StateStatus.UNCONSUMED), PageSpecification(DEFAULT_PAGE_NUM, 200)).states.map { it.state.data })
        }while((pageSpec.pageSize * (pageNumber -1)) <= rawResults.totalStatesAvailable)

        return mapper.writeValueAsString(states)
    }

    //get all containers
    @GetMapping(value = [""], produces = [MediaType.APPLICATION_JSON_VALUE])
    private fun getContainers() = ResponseEntity.ok(
            multiplePageGetContainers()
    )

    private fun multiplePageGetProductByTrackingID(trackingID: String): String? {
        var pageNumber = DEFAULT_PAGE_NUM
        val states = mutableListOf<ContainerState>()

        do{
            var pageSpec = PageSpecification(pageNumber = pageNumber, pageSize = 200)
            var rawResults = proxy.vaultQueryBy<ContainerState>(QueryCriteria.VaultQueryCriteria(),pageSpec)
            var results = rawResults.states.map {it.state.data}

            states.addAll(results)
            pageNumber++
        }while((pageSpec.pageSize * (pageNumber -1)) <= rawResults.totalStatesAvailable)

        return mapper.writeValueAsString(states.find {
            it.trackingID == UUID.fromString(trackingID) && it.custodian == proxy.nodeInfo().legalIdentities.first()
        })
    }

    //TODO: Shouldn't return null if not found, return not found
    @GetMapping(value = ["/{trackingID}"], produces = [MediaType.APPLICATION_JSON_VALUE])
    private fun getProductByTrackingID(@PathVariable trackingID: String) = ResponseEntity.ok(
            multiplePageGetProductByTrackingID(trackingID)
    )

    //TODO: make this async
    @PostMapping(value = [""], produces = [MediaType.APPLICATION_JSON_VALUE])
    fun createContainer(@RequestBody() request: CreateContainerRequest) = ResponseEntity.ok(
            mapOf("generatedID" to proxy.startFlowDynamic(CreateContainer::class.java, request).returnValue.getOrThrow())
    )

    @PutMapping(value = ["/{trackingID}"], produces = [MediaType.APPLICATION_JSON_VALUE])
    fun updateContainer(@PathVariable trackingID: UUID, @RequestBody request: CreateContainerRequest) = ResponseEntity.ok(
           mapOf("trackingID" to  proxy.startFlowDynamic(UpdateContainer::class.java, trackingID, request).returnValue.getOrThrow()
           )
    )

    //change custodian
    @PutMapping(value = ["/{trackingID}/custodian"], produces = [MediaType.APPLICATION_JSON_VALUE])
    fun claimContainer(@PathVariable trackingID: UUID) = ResponseEntity.ok(
           mapOf("trackingID" to proxy.startFlowDynamic(ClaimContainer::class.java, trackingID).returnValue.getOrThrow()
           )
    )

    //package item
    @PutMapping(value = ["/{containerTrackingID}/package"], produces = [MediaType.APPLICATION_JSON_VALUE])
    fun packageProduct(@PathVariable containerTrackingID: UUID, @RequestBody() productTrackingID : Contents) = ResponseEntity.ok(
            proxy.startFlowDynamic(PackageItem::class.java, productTrackingID.contents, containerTrackingID).returnValue.getOrThrow()
    )

    //unpackage item
    @PutMapping(value = ["/{containerTrackingID}/unpackage"], produces = [MediaType.APPLICATION_JSON_VALUE])
    fun unPackageProduct(@PathVariable containerTrackingID: UUID, @RequestBody() productTrackingID : Contents) = ResponseEntity.ok(
            proxy.startFlowDynamic(UnPackageItem::class.java, productTrackingID.contents, containerTrackingID).returnValue.getOrThrow()
    )

}