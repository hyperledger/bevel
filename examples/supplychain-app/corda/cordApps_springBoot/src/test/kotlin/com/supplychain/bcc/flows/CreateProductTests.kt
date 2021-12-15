package com.supplychain.bcc

import com.supplychain.bcc.contractstates.ProductState
import com.supplychain.bevel.CreateProductRequest
import org.junit.Test
import java.util.*
import kotlin.test.assertEquals
import kotlin.test.fail


class CreateProductTests : SupplyChainTests() {

    @Test
    fun `Create a Product`() {
        val product = createProduct(a, CreateProductRequest("Product Name", "Health", mapOf(), UUID.randomUUID(), listOf("BB")))

        //vaultCheck
        val stateA = a.transaction { a.services.vaultService.queryBy(ProductState::class.java).states.first().state }
        val stateB = b.transaction { a.services.vaultService.queryBy(ProductState::class.java).states.first().state }

        assertEquals(product, stateA.data.trackingID)
        assertEquals(product, stateB.data.trackingID)
        assertEquals(2, stateA.data.participants.size)

        println("The ProductState with LinearID ${product} was generated successfully")
    }

    @Test
    fun `Create a Product with a duplicate trackingID`() {
        try {
            val trackingID = UUID.randomUUID()
            createProduct(a, CreateProductRequest("Product Name", "Health", mapOf(), trackingID, listOf("BB")))

            // createProductFlowShouldFail
            createProduct(b, CreateProductRequest("Product Name", "Health", mapOf(), trackingID, listOf("AA")))

            fail()
        } catch(e: IllegalArgumentException){
            println("Exception successfully caught")
        }
    }
}