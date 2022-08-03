package com.supplychain.bcc

import com.supplychain.bcc.contractstates.ContainerState
import com.supplychain.bcc.contractstates.ProductState
import com.supplychain.bevel.CreateContainerRequest
import com.supplychain.bevel.CreateProductRequest
import org.junit.Test
import java.util.*
import kotlin.test.assertEquals


class UpdateContainerTests : SupplyChainTests() {

    @Test
    fun `Update a Container`() {
        val trackingID = UUID.randomUUID()
        val updateRequest = CreateContainerRequest("UnHealth", mapOf(), trackingID, listOf("BB"))
        createContainer(a, CreateContainerRequest("Health", mapOf(), trackingID, listOf("BB")))

        updateContainer(a, trackingID, updateRequest)

        //vaultCheck
        val state = a.transaction { a.services.vaultService.queryBy(ContainerState::class.java).states.first().state }

        assertEquals("UnHealth", state.data.health)

        println("The Container was updated successfully")
    }

    @Test
    fun `Update a Container containing a Product`() {
        val containerTrackingID = UUID.randomUUID()
        val productTrackingID = UUID.randomUUID()

        val updateRequest = CreateContainerRequest("UnHealth", mapOf(), containerTrackingID, listOf("BB"))
        createContainer(a, CreateContainerRequest("Health", mapOf(), containerTrackingID, listOf("BB")))
        createProduct(a, CreateProductRequest("Product Name", "Health", mapOf(), productTrackingID, listOf("BB")))

        packageProduct(a, productTrackingID, containerTrackingID)

        updateContainer(a, containerTrackingID, updateRequest)

        mockNetwork.waitQuiescent()

        //vaultCheck
        val containerA = a.transaction { a.services.vaultService.queryBy(ContainerState::class.java).states.first().state }
        val productA = a.transaction { a.services.vaultService.queryBy(ProductState::class.java).states.first().state }

        assertEquals("UnHealth", containerA.data.health)
        assertEquals("UnHealth", productA.data.health)

        println("The Container and its contained product was updated successfully")
    }

    @Test
    fun `Update a Container containing a Container`() {
        val containerTrackingID = UUID.randomUUID()
        val containerContentsTrackingID = UUID.randomUUID()

        val updateRequest = CreateContainerRequest("UnHealth", mapOf(), containerTrackingID, listOf("BB"))
        createContainer(a, CreateContainerRequest("Health", mapOf(), containerTrackingID, listOf("BB")))
        createContainer(a, CreateContainerRequest("Health", mapOf(), containerContentsTrackingID, listOf("BB")))

        packageProduct(a, containerContentsTrackingID, containerTrackingID)

        updateContainer(a, containerTrackingID, updateRequest)

        mockNetwork.waitQuiescent()

        //vaultCheck
        val containerA = a.transaction { a.services.vaultService.queryBy(ContainerState::class.java).states.find { it.state.data.trackingID == containerTrackingID } }
        val containedA = a.transaction { a.services.vaultService.queryBy(ContainerState::class.java).states.find { it.state.data.trackingID == containerContentsTrackingID } }

        assertEquals("UnHealth", containerA?.state?.data?.health)
        assertEquals("UnHealth", containedA?.state?.data?.health)

        println("The Container and its contained container was claimed successfully")
    }

}