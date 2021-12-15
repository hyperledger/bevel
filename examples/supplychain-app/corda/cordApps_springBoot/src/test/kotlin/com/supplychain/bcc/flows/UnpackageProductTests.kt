package com.supplychain.bcc

import com.supplychain.bcc.contractstates.ContainerState
import com.supplychain.bcc.contractstates.ProductState
import com.supplychain.bevel.CreateContainerRequest
import com.supplychain.bevel.CreateProductRequest
import org.junit.Test
import java.util.*
import kotlin.test.assertEquals
import kotlin.test.assertNotEquals


class UnpackageProductTests : SupplyChainTests() {

    @Test
    fun `Create a Container`() {
        val result = createContainer(a, CreateContainerRequest("Health", mapOf(), UUID.randomUUID(), listOf("BB")))

        //vaultCheck
        assertEquals(result, a.transaction { a.services.vaultService.queryBy(ContainerState::class.java).states.first().state.data.trackingID })
        assertEquals(result, b.transaction { b.services.vaultService.queryBy(ContainerState::class.java).states.first().state.data.trackingID })

        println("The ContainerState with LinearID ${result} was generated successfully")
    }

    @Test
    fun `Pack and Unpack product in a container`() {

        //Pack product into container
        val productTrackID = UUID.randomUUID()
        val containerTrackID = UUID.randomUUID()

        //create product and container
        createProduct(a, CreateProductRequest("Product Name", "Health", mapOf(), productTrackID, listOf("BB")))
        createContainer(a, CreateContainerRequest("Health", mapOf(), containerTrackID, listOf("BB")))

        packageProduct(a, productTrackID, containerTrackID)

        mockNetwork.waitQuiescent()

        //query vault for each state
        val statePackProduct = a.transaction { a.services.vaultService.queryBy(ProductState::class.java).states.first().state }
        val statePackContainer = a.transaction { a.services.vaultService.queryBy(ContainerState::class.java).states.first().state }

        //check if the containerId was set correctly and contents updated
        assertEquals(containerTrackID, statePackProduct.data.containerID, "The product should have the the containers tracking id as its containerID")
        assert(productTrackID in statePackContainer.data.contents)



        //Unpacking a product in a container

        unpackageProduct(a, productTrackID, containerTrackID)

        mockNetwork.waitQuiescent()

        val stateUnPackProduct = a.transaction { a.services.vaultService.queryBy(ProductState::class.java).states.first().state }
        val stateUnPackContainer = a.transaction { a.services.vaultService.queryBy(ContainerState::class.java).states.first().state }
        
        assertNotEquals(containerTrackID, stateUnPackProduct.data.containerID, "The product should not have the containers tracking id as its containerID")

        assert(productTrackID !in stateUnPackContainer.data.contents) //product tracking id should not be in container contents anymore

    }

}

