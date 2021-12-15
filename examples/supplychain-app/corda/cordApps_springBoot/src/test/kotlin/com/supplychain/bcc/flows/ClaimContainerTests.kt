package com.supplychain.bcc

import com.supplychain.bcc.contractstates.ContainerState
import com.supplychain.bcc.contractstates.ProductState
import com.supplychain.bevel.CreateContainerRequest
import com.supplychain.bevel.CreateProductRequest
import net.corda.core.identity.CordaX500Name
import org.junit.Test
import java.util.*
import kotlin.test.assertEquals


class ClaimContainerTests : SupplyChainTests() {

    @Test
    fun `Claim an empty Container`() {
        val containerTrackingID = UUID.randomUUID()

        createContainer(a, CreateContainerRequest("Health", mapOf(), containerTrackingID, listOf("BB")))
        claimContainer(b, containerTrackingID)

        mockNetwork.waitQuiescent()

        //vaultCheck
        val containerA = a.transaction { a.services.vaultService.queryBy(ContainerState::class.java).states.first().state }
        val containerB = b.transaction { b.services.vaultService.queryBy(ContainerState::class.java).states.first().state }

        assertEquals(CordaX500Name("BB", "Locality", "US"), containerA.data.custodian.name)
        assertEquals(CordaX500Name("BB", "Locality", "US"), containerB.data.custodian.name)

        println("The Container was claimed successfully")
    }

    @Test
    fun `Claim a Container containing a Product`() {
        val containerTrackingID = UUID.randomUUID()
        val productTrackingID = UUID.randomUUID()

        createContainer(a, CreateContainerRequest("Health", mapOf(), containerTrackingID, listOf("BB")))
        createProduct(a, CreateProductRequest("Product Name", "Health", mapOf(), productTrackingID, listOf("BB")))

        packageProduct(a, productTrackingID, containerTrackingID)

        claimContainer(b, containerTrackingID)

        mockNetwork.waitQuiescent()

        //vaultCheck
        val containerA = a.transaction { a.services.vaultService.queryBy(ContainerState::class.java).states.first().state }
        val containerB = b.transaction { b.services.vaultService.queryBy(ContainerState::class.java).states.first().state }
        val productA = a.transaction { a.services.vaultService.queryBy(ProductState::class.java).states.first().state }
        val productB = b.transaction { b.services.vaultService.queryBy(ProductState::class.java).states.first().state }

        assertEquals(CordaX500Name("BB", "Locality", "US"), containerA.data.custodian.name)
        assertEquals(CordaX500Name("BB", "Locality", "US"), containerB.data.custodian.name)
        assertEquals(CordaX500Name("BB", "Locality", "US"), productA.data.custodian.name)
        assertEquals(CordaX500Name("BB", "Locality", "US"), productB.data.custodian.name)

        println("The Container and its contained product was claimed successfully")
    }

    @Test
    fun `Claim a Container containing a Container`() {
        val containerTrackingID = UUID.randomUUID()
        val containerContentsTrackingID = UUID.randomUUID()

        createContainer(a, CreateContainerRequest("Health", mapOf(), containerTrackingID, listOf("BB")))
        createContainer(a, CreateContainerRequest("Health", mapOf(), containerContentsTrackingID, listOf("BB")))

        packageProduct(a, containerContentsTrackingID, containerTrackingID)

        claimContainer(b, containerTrackingID)

        mockNetwork.waitQuiescent()

        //vaultCheck
        val containerA = a.transaction { a.services.vaultService.queryBy(ContainerState::class.java).states.find { it.state.data.trackingID == containerTrackingID } }
        val containerB = b.transaction { b.services.vaultService.queryBy(ContainerState::class.java).states.find { it.state.data.trackingID == containerTrackingID } }
        val containedA = a.transaction { a.services.vaultService.queryBy(ContainerState::class.java).states.find { it.state.data.trackingID == containerContentsTrackingID } }
        val containedB = b.transaction { b.services.vaultService.queryBy(ContainerState::class.java).states.find { it.state.data.trackingID == containerContentsTrackingID } }

        assertEquals(CordaX500Name("BB", "Locality", "US"), containerA?.state?.data?.custodian?.name)
        assertEquals(CordaX500Name("BB", "Locality", "US"), containerB?.state?.data?.custodian?.name)
        assertEquals(CordaX500Name("BB", "Locality", "US"), containedA?.state?.data?.custodian?.name)
        assertEquals(CordaX500Name("BB", "Locality", "US"), containedB?.state?.data?.custodian?.name)

        println("The Container and its contained product was claimed successfully")
    }

}