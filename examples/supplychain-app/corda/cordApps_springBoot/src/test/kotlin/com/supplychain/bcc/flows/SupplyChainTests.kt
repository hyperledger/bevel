package com.supplychain.bcc

import net.corda.core.identity.CordaX500Name
import net.corda.core.utilities.getOrThrow
import net.corda.testing.node.MockNetwork
import net.corda.testing.node.StartedMockNode
import org.testng.annotations.AfterMethod
import org.testng.annotations.BeforeMethod
import java.util.*

abstract class SupplyChainTests {
    lateinit var mockNetwork: MockNetwork
    lateinit var a: StartedMockNode
    lateinit var b: StartedMockNode
    lateinit var c: StartedMockNode

    @BeforeMethod
    fun setup() {
        mockNetwork = MockNetwork(listOf("com.supplychain.bcc"), threadPerNode = true, networkSendManuallyPumped = false)

        a = mockNetwork.createPartyNode(CordaX500Name("AA", "Manufacturer", "AA",  "Locality",null,"US"))
        b = mockNetwork.createPartyNode(CordaX500Name("BB", "Warehouse", "AA",  "Locality",null,"US"))
        c = mockNetwork.createPartyNode(CordaX500Name("CC", "Store", "AA",  "Locality",null,"US"))

        //a.registerInitiatedFlow(ClaimOwnershipResponder::class.java)
        //b.registerInitiatedFlow(ClaimOwnershipResponder::class.java)
        //c.registerInitiatedFlow(ClaimOwnershipResponder::class.java)
    }

    @AfterMethod
    fun tearDown() {
        mockNetwork.stopNodes()
    }

    protected fun createProduct(creator: StartedMockNode, request: CreateProductRequest) : UUID {
        val flow = CreateProduct(request)
        return creator.startFlow(flow).getOrThrow()
    }

    protected fun claimProduct(claimant: StartedMockNode, trackingID: UUID) : UUID {
        val flow = ClaimTrackable(trackingID)
        return claimant.startFlow(flow).getOrThrow()
    }

    protected fun updateProduct(custodian: StartedMockNode, trackingID: UUID, request: CreateProductRequest) : UUID {
        val flow = UpdateProduct(trackingID, request)
        return custodian.startFlow(flow).getOrThrow()
    }

    protected fun createContainer(creator: StartedMockNode, request: CreateContainerRequest) : UUID {
        val flow = CreateContainer(request)
        return creator.startFlow(flow).getOrThrow()
    }

    protected fun packageProduct(custodian: StartedMockNode, trackableID: UUID, containerID: UUID) : UUID {
        val flow = PackageItem(trackableID, containerID)
        return custodian.startFlow(flow).getOrThrow()
    }

    protected fun unpackageProduct(custodian: StartedMockNode, trackableID: UUID, containerID: UUID) : UUID {
        val flow = UnPackageItem(trackableID, containerID)
        return custodian.startFlow(flow).getOrThrow()
    }

    protected fun claimContainer(claimant: StartedMockNode, trackingID: UUID) : UUID {
        val flow = ClaimContainer(trackingID)
        return claimant.startFlow(flow).getOrThrow()
    }

    protected fun updateContainer(custodian: StartedMockNode, trackingID: UUID, request: CreateContainerRequest) : UUID {
        val flow = UpdateContainer(trackingID, request)
        return custodian.startFlow(flow).getOrThrow()
    }
}