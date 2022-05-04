package com.supplychain.bevel

import co.paralleluniverse.fibers.Suspendable
import com.supplychain.bcc.contractstates.ProductState
import com.supplychain.bcc.contractstates.SupplyChainContract
import net.corda.core.flows.*
import net.corda.core.node.services.queryBy
import net.corda.core.transactions.SignedTransaction
import net.corda.core.transactions.TransactionBuilder
import net.corda.core.utilities.ProgressTracker
import net.corda.core.identity.CordaX500Name
import java.sql.Timestamp
import java.util.*

/***************************************************************************
 * Definition of flow to claim ownership of TrackableState
 * @returns something
 ***************************************************************************/

@InitiatingFlow
@StartableByRPC
class UpdateProduct(val trackingID: UUID, val request: CreateProductRequest) : FlowLogic<UUID>() {

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
    override fun call() : UUID {
        progressTracker.currentStep = BUILD_TRANSACTION

        val input = serviceHub.vaultService.queryBy<ProductState>().states.find {
            it.state.data.trackingID == trackingID
        } ?: throw IllegalArgumentException("No Product with ID $request.trackingID found.")

        val timestamp = Timestamp(System.currentTimeMillis()).time

        val output = ProductState(
                input.state.data.productName,
                request.health,
                input.state.data.sold,
                input.state.data.recalled,
                request.misc,
                ourIdentity,
                trackingID,
                timestamp,
                participants = input.state.data.participants
        )

        val notary = serviceHub.networkMapCache.getNotary(CordaX500Name.parse("O=Notary Service,OU=Notary,L=London,C=GB"))
                    ?: throw IllegalStateException("Notary not found on network")    
        val txBuilder = TransactionBuilder(notary)
                .addInputState(input)
                .addOutputState(output, SupplyChainContract.ID)
                .addCommand(SupplyChainContract.Commands.UpdateProduct(), output.participants.map { it.owningKey })

        progressTracker.currentStep = VERIFY_TRANSACTION
        txBuilder.verify(serviceHub)

        progressTracker.currentStep = SIGN_TRANSACTION
        val tx = serviceHub.signInitialTransaction(txBuilder)

        progressTracker.currentStep = COLLECT_COUNTERPARTY_SIG
        val participants = output.participants - ourIdentity
        val flowSessions = participants.map { initiateFlow(it) }
        val stx = subFlow(CollectSignaturesFlow(tx, flowSessions))

        progressTracker.currentStep = FINALISE_TRANSACTION
        this.subFlow(FinalityFlow(stx,flowSessions, Companion.FINALISE_TRANSACTION.childProgressTracker()))

        return output.trackingID
    }
}

@InitiatedBy(UpdateProduct::class)
open class UpdateProductResponder(val counterpartySession: FlowSession) : FlowLogic<SignedTransaction>() {

    @Suspendable
    override fun call() : SignedTransaction {
        val signTransactionFlow = object : SignTransactionFlow(counterpartySession) {

            @Suspendable
            override fun checkTransaction(stx: SignedTransaction) {
                require(stx.inputs.size == 1) { "There should be one input for this transaction" }
                require(stx.tx.outputStates.size == 1) { "There should be only one output for this transaction" }

            }

        }
        val txId = subFlow(signTransactionFlow).id
        return subFlow(ReceiveFinalityFlow(counterpartySession, expectedTxId = txId))    }
}