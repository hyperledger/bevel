package com.supplychain.bcc

import com.supplychain.bcc.contractstates.ProductState
import com.supplychain.bevel.CreateProductRequest
import net.corda.core.identity.CordaX500Name
import org.junit.Test
import java.util.*
import kotlin.test.assertEquals


class ClaimProductTests : SupplyChainTests() {

    @Test
    fun `Claim a Product`() {
        val trackingID = UUID.randomUUID()
        createProduct(a, CreateProductRequest("Product Name", "Health", mapOf(), trackingID, listOf("BB")))

        val result = claimProduct(b, trackingID)

        mockNetwork.waitQuiescent()

        //vaultCheck
        val stateA = a.transaction { a.services.vaultService.queryBy(ProductState::class.java).states.first().state }
        val stateB = b.transaction { b.services.vaultService.queryBy(ProductState::class.java).states.first().state }

        assertEquals(result, stateA.data.trackingID)
        assertEquals(result, stateB.data.trackingID)
        assertEquals(CordaX500Name("BB", "Locality", "US"), stateA.data.custodian.name)
        assertEquals(CordaX500Name("BB", "Locality", "US"), stateB.data.custodian.name)

        println("The ProductState with LinearID ${result} was successfully claimed")
    }

}