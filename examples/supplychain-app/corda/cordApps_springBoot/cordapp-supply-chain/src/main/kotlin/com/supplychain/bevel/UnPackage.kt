package com.supplychain.bevel

import co.paralleluniverse.fibers.Suspendable
import com.supplychain.bcc.contractstates.ContainerState
import com.supplychain.bcc.contractstates.SupplyChainContract
import com.supplychain.bcc.contractstates.TrackableState
import net.corda.core.flows.*
import net.corda.core.identity.Party
import net.corda.core.node.services.queryBy
import net.corda.core.transactions.SignedTransaction
import net.corda.core.transactions.TransactionBuilder
import net.corda.core.utilities.ProgressTracker
import net.corda.core.identity.CordaX500Name
import java.util.*

/********************************************************
* Definition of flow to unpackage items into containers
* @returns something
********************************************************/


@InitiatingFlow
@StartableByRPC
class UnPackageItem (val productTrackingID: UUID, val containerTrackingID: UUID) : FlowLogic<UUID>() {
    companion object {
        object GETTING_COUNTERPARTIES: ProgressTracker.Step("Gathering the counterparties.")
        object BUILD_TRANSACTION : ProgressTracker.Step("Building the transaction.")
        object VERIFY_TRANSACTION : ProgressTracker.Step("Verifying the transaction.")
        object SIGN_TRANSACTION : ProgressTracker.Step("I sign the transaction.")
        object COLLECT_COUNTERPARTY_SIG : ProgressTracker.Step("The counterparty signs the transaction.") {
            override fun childProgressTracker() = CollectSignaturesFlow.tracker()
        }

        object FINALISE_TRANSACTION : ProgressTracker.Step("Obtaining notary signature and recording transaction.") {
            override fun childProgressTracker() = FinalityFlow.tracker()
        }

        fun tracker() = ProgressTracker(
                GETTING_COUNTERPARTIES,
                BUILD_TRANSACTION,
                VERIFY_TRANSACTION,
                SIGN_TRANSACTION,
                COLLECT_COUNTERPARTY_SIG,
                FINALISE_TRANSACTION
        )
    }

    override val progressTracker = tracker()

    @Suspendable
    override fun call():UUID {
        progressTracker.currentStep = BUILD_TRANSACTION

        //Query vault for a TrackableState to be packaged and a ContainerState that will 'hold' the TrackableState
        //These states are inputs for the Transaction builder
        val trackInput = serviceHub.vaultService.queryBy<TrackableState>().states.find {
            it.state.data.trackingID == productTrackingID
        } ?: throw IllegalArgumentException("No Trackable with ID $productTrackingID found.")

        val containerInput = serviceHub.vaultService.queryBy<ContainerState>().states.find {
            it.state.data.trackingID == containerTrackingID
        } ?: throw IllegalArgumentException("No Container with ID $containerTrackingID found.")

        //Generate TrackableState output with containerID = null
        val trackOutput = trackInput.state.data.withNewTracking(containerID = null)

        //Generate ContainerState output with the product removed from the container
        val containerOutput = containerInput.state.data.withRemovedProduct(productTrackingID)

        val notary = serviceHub.networkMapCache.getNotary(CordaX500Name.parse("O=Notary Service,OU=Notary,L=London,C=GB"))
                    ?: throw IllegalStateException("Notary not found on network")    
        val txBuilder = TransactionBuilder(notary)        
                .addInputState(trackInput)
                .addInputState(containerInput)
                .addOutputState(trackOutput, SupplyChainContract.ID)
                .addOutputState(containerOutput, SupplyChainContract.ID)
                .addCommand(SupplyChainContract.Commands.UnpackContainer(), trackOutput.participants.map { it.owningKey })

        progressTracker.currentStep = VERIFY_TRANSACTION
        txBuilder.verify(serviceHub)

        progressTracker.currentStep = SIGN_TRANSACTION
        val tx = serviceHub.signInitialTransaction(txBuilder)

        progressTracker.currentStep = COLLECT_COUNTERPARTY_SIG
        val participants = trackOutput.participants - ourIdentity
        val flowSessions = participants.map { initiateFlow(it as Party) }
        val stx = subFlow(CollectSignaturesFlow(tx, flowSessions))

        progressTracker.currentStep = FINALISE_TRANSACTION
        this.subFlow(FinalityFlow(stx, flowSessions, Companion.FINALISE_TRANSACTION.childProgressTracker()))

        return containerTrackingID
    }
}

@InitiatedBy(UnPackageItem::class)
open class UnPackageItemResponder(val counterpartySession: FlowSession) : FlowLogic<SignedTransaction>() {

    @Suspendable
    override fun call() :  SignedTransaction {
            val signTransactionFlow = object : SignTransactionFlow(counterpartySession) {

                @Suspendable
                override fun checkTransaction(stx: SignedTransaction) {
                    require(stx.inputs.size == 2) { "There should be two inputs for this transaction" }
                    require(stx.tx.outputStates.size == 2) { "There should be two outputs for this transaction" }
                }

            }
        val txId = subFlow(signTransactionFlow).id
        return subFlow(ReceiveFinalityFlow(counterpartySession, expectedTxId = txId))    }
}


