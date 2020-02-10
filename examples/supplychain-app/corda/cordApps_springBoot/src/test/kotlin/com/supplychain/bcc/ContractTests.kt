package com.supplychain.bcc

import com.supplychain.bcc.contractstates.ContainerState
import com.supplychain.bcc.contractstates.ProductState
import com.supplychain.bcc.contractstates.SupplyChainContract
import net.corda.core.contracts.TransactionVerificationException
import net.corda.core.identity.CordaX500Name
import net.corda.testing.core.TestIdentity
import net.corda.testing.node.MockServices
import net.corda.testing.node.ledger
import org.junit.Test
import java.util.*
import kotlin.test.assertFailsWith


class ContractTests {
    private val ledgerServices = MockServices(listOf("com.supplychain.bcc.contractstates"))
    private val PartyA = TestIdentity(CordaX500Name("AA", "London", "GB"))
    private val PartyB = TestIdentity(CordaX500Name("BB", "London", "GB"))

    private val validInputDataProduct = ProductState(
            "Product Name",
            "Health",
            false,
            false,
            mapOf(),
            PartyA.party,
            UUID.randomUUID(),
            0,
            participants = listOf(PartyA.party, PartyB.party))

    private val validInputDataContainer = ContainerState(
            "Health",
            mapOf(),
            PartyB.party,
            UUID.randomUUID(),
            0,
            participants = listOf(PartyA.party, PartyB.party))

    /** CreateProduct **/
    @Test
    fun `Valid Product State `() {
        ledgerServices.ledger {
            transaction {
                output(SupplyChainContract.ID, validInputDataProduct)
                command(listOf(PartyA.publicKey), SupplyChainContract.Commands.CreateProduct())
                verifies()
            }
        }

    }

    @Test
    fun `Missing Custodian from Participants ProductState`() {
        assertFailsWith(TransactionVerificationException.ContractRejection::class) {
            ledgerServices.ledger {
                transaction {
                    output(SupplyChainContract.ID, validInputDataProduct.copy(participants = listOf(PartyB.party)))
                    command(listOf(PartyA.publicKey), SupplyChainContract.Commands.CreateProduct())
                    verifies()
                }
            }
        }
    }

    @Test
    fun `Inputs not allowed on creation Product State `() {
        assertFailsWith(TransactionVerificationException.ContractRejection::class) {
            ledgerServices.ledger {
                transaction {
                    input(SupplyChainContract.ID, validInputDataProduct)
                    output(SupplyChainContract.ID, validInputDataProduct)
                    command(listOf(PartyA.publicKey), SupplyChainContract.Commands.CreateProduct())
                    verifies()
                }
            }
        }
    }

    @Test
    fun `Products not sold on create`() {
        assertFailsWith(TransactionVerificationException.ContractRejection::class) {
            ledgerServices.ledger {
                transaction {
                    output(SupplyChainContract.ID, validInputDataProduct.copy(sold = true))
                    command(listOf(PartyA.publicKey), SupplyChainContract.Commands.CreateProduct())
                    verifies()
                }
            }
        }
    }

    @Test
    fun `Products not recalled on create`() {
        assertFailsWith(TransactionVerificationException.ContractRejection::class) {
            ledgerServices.ledger {
                transaction {
                    output(SupplyChainContract.ID, validInputDataProduct.copy(recalled = true))
                    command(listOf(PartyA.publicKey), SupplyChainContract.Commands.CreateProduct())
                    verifies()
                }
            }
        }
    }

    /** CreateContainer **/
    @Test
    fun `Valid Container State `() {
        ledgerServices.ledger {
            transaction {
                output(SupplyChainContract.ID, validInputDataContainer)
                command(listOf(PartyB.publicKey), SupplyChainContract.Commands.CreateContainer())
                verifies()
            }
        }

    }

    @Test
    fun `Missing Custodian from Participants ContainerState`() {
        assertFailsWith(TransactionVerificationException.ContractRejection::class) {
            ledgerServices.ledger {
                transaction {
                    output(SupplyChainContract.ID, validInputDataContainer.copy(participants = listOf(PartyA.party)))
                    command(listOf(PartyB.publicKey), SupplyChainContract.Commands.CreateContainer())
                    verifies()
                }
            }
        }
    }

    @Test
    fun `Inputs not allowed on creation ContainerState `() {
        assertFailsWith(TransactionVerificationException.ContractRejection::class) {
            ledgerServices.ledger {
                transaction {
                    input(SupplyChainContract.ID, validInputDataContainer)
                    output(SupplyChainContract.ID, validInputDataContainer)
                    command(listOf(PartyB.publicKey), SupplyChainContract.Commands.CreateContainer())
                    verifies()
                }
            }
        }
    }
    /**Ownership change**/
    @Test
    fun `Valid ownership change`(){
        ledgerServices.ledger {
            transaction {
                input(SupplyChainContract.ID, validInputDataProduct)
                output(SupplyChainContract.ID,validInputDataProduct.copy(custodian = PartyB.party))
                command(listOf(PartyA.publicKey,PartyB.publicKey), SupplyChainContract.Commands.ClaimTrackable())
                verifies()
            }
        }
    }
    @Test
    fun `Valid container ownership change`(){
        ledgerServices.ledger {
            transaction {
                input(SupplyChainContract.ID, validInputDataContainer.copy(custodian = PartyA.party))
                input(SupplyChainContract.ID, validInputDataProduct)
                output(SupplyChainContract.ID,validInputDataContainer.copy(custodian = PartyB.party))
                output(SupplyChainContract.ID,validInputDataProduct.copy(custodian = PartyB.party))
                command(listOf(PartyA.publicKey,PartyB.publicKey), SupplyChainContract.Commands.ClaimContainer())
                verifies()
            }
        }
    }

    @Test
    fun `Attempt to change more than ownership change`(){
        assertFailsWith(TransactionVerificationException.ContractRejection::class) {
            ledgerServices.ledger {
                transaction {
                    input(SupplyChainContract.ID, validInputDataProduct)
                    output(SupplyChainContract.ID, validInputDataProduct.copy(custodian = PartyB.party, sold = true))
                    command(listOf(PartyA.publicKey, PartyB.publicKey), SupplyChainContract.Commands.ClaimTrackable())
                    verifies()
                }
            }
        }
    }

    /**Package **/
    @Test
    fun `Valid packaging of items`(){
        ledgerServices.ledger {
            transaction {
                input(SupplyChainContract.ID, validInputDataProduct)
                input(SupplyChainContract.ID, validInputDataContainer.copy(custodian = PartyA.party))
                output(SupplyChainContract.ID,validInputDataProduct.copy(containerID = validInputDataContainer.trackingID))
                output(SupplyChainContract.ID,validInputDataContainer.copy(contents = mutableListOf(validInputDataProduct.trackingID ),custodian = PartyA.party))

                command(listOf(PartyA.publicKey,PartyB.publicKey), SupplyChainContract.Commands.PackContainer())
                verifies()
            }
        }
    }

    @Test
    fun `Different custodian of container and product`(){
        assertFailsWith(TransactionVerificationException.ContractRejection::class) {

            ledgerServices.ledger {
                transaction {
                    input(SupplyChainContract.ID, validInputDataProduct)
                    input(SupplyChainContract.ID, validInputDataContainer.copy())
                    output(SupplyChainContract.ID, validInputDataProduct.copy(containerID = validInputDataContainer.trackingID))
                    output(SupplyChainContract.ID, validInputDataContainer.copy(contents = mutableListOf(validInputDataProduct.trackingID)))

                    command(listOf(PartyA.publicKey, PartyB.publicKey), SupplyChainContract.Commands.PackContainer())
                    verifies()
                }
            }
        }
    }

}