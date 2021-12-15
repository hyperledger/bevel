package com.supplychain.bcc.webserver

import com.supplychain.bcc.contractstates.ProductState
import com.supplychain.bevel.ClaimTrackable
import com.supplychain.bevel.CreateProduct
import com.supplychain.bevel.CreateProductRequest
import com.supplychain.bevel.UpdateProduct
import net.corda.client.jackson.JacksonSupport
import net.corda.core.messaging.vaultQueryBy
import net.corda.core.utilities.getOrThrow
import org.slf4j.LoggerFactory
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.util.*


@RestController
@RequestMapping("/api/v1/product")
class ProductController(rpc: NodeRPCConnection) {

    companion object {
        private val logger = LoggerFactory.getLogger(RestController::class.java)
    }

    private val proxy = rpc.proxy
    private val mapper = JacksonSupport.createDefaultMapper(proxy)


    @GetMapping(value = [""], produces = [MediaType.APPLICATION_JSON_VALUE])
    private fun getProducts() = ResponseEntity.ok(
            mapper.writeValueAsString(proxy.vaultQueryBy<ProductState>().states.map { it.state.data })
    )
    @GetMapping(value = ["/containerless"], produces = [MediaType.APPLICATION_JSON_VALUE])
    private fun getUnClaimedProducts() = ResponseEntity.ok(
            mapper.writeValueAsString(proxy.vaultQueryBy<ProductState>().states.map { it.state.data }.filter { it.containerID == null })
    )

    //TODO: Shouldn't return null if not found, return not found
    @GetMapping(value = ["/{trackingID}"], produces = [MediaType.APPLICATION_JSON_VALUE])
    private fun getProductByTrackingID(@PathVariable trackingID: String) = ResponseEntity.ok(
            mapper.writeValueAsString(proxy.vaultQueryBy<ProductState>().states.find {
                it.state.data.trackingID == UUID.fromString(trackingID) && it.state.data.custodian == proxy.nodeInfo().legalIdentities.first()
            }?.state?.data)
    )

    //TODO: make this async
    @PostMapping(value = [""], produces = [MediaType.APPLICATION_JSON_VALUE])
    fun createProduct(@RequestBody() request: CreateProductRequest) = ResponseEntity.ok(
            mapOf("generatedID" to proxy.startFlowDynamic(CreateProduct::class.java, request).returnValue.getOrThrow())
    )

    @PutMapping(value = ["/{trackingID}"], produces = [MediaType.APPLICATION_JSON_VALUE])
    fun updateProduct(@PathVariable trackingID: UUID, @RequestBody request: CreateProductRequest) = ResponseEntity.ok(
            proxy.startFlowDynamic(UpdateProduct::class.java, trackingID, request).returnValue.getOrThrow()
    )

    @PutMapping(value = ["/{trackingID}/custodian"], produces = [MediaType.APPLICATION_JSON_VALUE])
    fun claimProduct(@PathVariable trackingID: UUID) = ResponseEntity.ok(
            proxy.startFlowDynamic(ClaimTrackable::class.java, trackingID).returnValue.getOrThrow()
    )
}