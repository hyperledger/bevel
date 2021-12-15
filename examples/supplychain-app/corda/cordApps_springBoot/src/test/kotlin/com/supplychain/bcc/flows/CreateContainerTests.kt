package com.supplychain.bcc

import com.supplychain.bcc.contractstates.ContainerState
import com.supplychain.bevel.CreateContainerRequest
import org.junit.Test
import java.util.*
import kotlin.test.assertEquals
import kotlin.test.fail


class CreateContainerTests : SupplyChainTests() {

    @Test
    fun `Create a Container`() {
        val result = createContainer(a, CreateContainerRequest("Health", mapOf(), UUID.randomUUID(), listOf("BB")))

        //vaultCheck
        assertEquals(result, a.transaction{ a.services.vaultService.queryBy(ContainerState::class.java).states.first().state.data.trackingID })
        assertEquals(result, b.transaction{ b.services.vaultService.queryBy(ContainerState::class.java).states.first().state.data.trackingID })

        println("The ContainerState with LinearID ${result} was generated successfully")
    }

    @Test
    fun `Create a Container with a duplicate trackingID`() {
        try {
            val trackingID = UUID.randomUUID()
            createContainer(a, CreateContainerRequest("Health", mapOf(), trackingID, listOf("BB")))

            //this should fail
            createContainer(b, CreateContainerRequest("Health ", mapOf(), trackingID, listOf("AA")))

            fail()
        }catch(e: IllegalArgumentException){
            println("Exception successfully caught")
        }
    }

}