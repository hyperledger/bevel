package com.supplychain.bevel

import co.paralleluniverse.fibers.Suspendable
import com.supplychain.bcc.contractstates.ProductState
import com.supplychain.bcc.contractstates.SupplyChainContract
import net.corda.core.flows.*
import net.corda.core.identity.Party
import net.corda.core.node.services.queryBy
import net.corda.core.transactions.SignedTransaction
import net.corda.core.transactions.TransactionBuilder
import net.corda.core.utilities.ProgressTracker
import net.corda.core.identity.CordaX500Name
import java.sql.Timestamp
import java.util.*

/************************************************************
 * Definition of flow to Create a ProductState and responder
 * @returns something
 ************************************************************/

@InitiatingFlow
@StartableByRPC
class CreateProduct(val request: CreateProductRequest) : FlowLogic<UUID>() {

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
        // Create participants list for parties in the chain of custodianship
        progressTracker.currentStep = GETTING_COUNTERPARTIES

        val participants: MutableList<Party> = mutableListOf()
        request.counterparties.forEach {
            partyName ->
            participants.add(PartyLookup(partyName))
        }
        val flowSessions = participants.map { initiateFlow(it) }

        //Add yourself to participants
        participants.add(ourIdentity)

        val timestamp = Timestamp(System.currentTimeMillis()).time
        //Create transaction
        progressTracker.currentStep = BUILD_TRANSACTION
        val output = ProductState(
                request.productName,
                null,
                false,
                false,
                request.misc,
                ourIdentity,
                request.trackingID,
                timestamp,
                participants = participants
        )
        val notary = serviceHub.networkMapCache.getNotary(CordaX500Name.parse("O=Notary Service,OU=Notary,L=London,C=GB"))
                    ?: throw IllegalStateException("Notary not found on network")    
        val txBuilder = TransactionBuilder(notary)
                .addOutputState(output, SupplyChainContract.ID)
                .addCommand(SupplyChainContract.Commands.CreateProduct(), participants.map { it.owningKey })

        progressTracker.currentStep = VERIFY_TRANSACTION
        if(ourIdentity.name.organisationUnit != "Manufacturer"){
            throw Exception("User not allow to make this request")
        }

        var states = serviceHub.vaultService.queryBy<ProductState>().states.filter {
            it.state.data.trackingID == request.trackingID
        }
        if(states.size > 0) {
            throw IllegalArgumentException("Container with Tracking ID ${request.trackingID} already exists.")
        }

        txBuilder.verify(serviceHub)
        val tx = serviceHub.signInitialTransaction(txBuilder)

        progressTracker.currentStep = SIGN_TRANSACTION
        val stx = subFlow(CollectSignaturesFlow(tx, flowSessions))

        progressTracker.currentStep = FINALISE_TRANSACTION
        this.subFlow(FinalityFlow(stx, flowSessions))

        return output.trackingID
    }

    fun PartyLookup(name:String):Party{
        return (serviceHub.identityService.partiesFromName(name, true).singleOrNull()
                ?: throw IllegalArgumentException("No exact match found for name: $name."))
    }

}


@InitiatedBy(CreateProduct::class)
open class CreateProductResponder(val counterpartySession: FlowSession) : FlowLogic<SignedTransaction>() {

    @Suspendable
    override fun call() : SignedTransaction {
        val signTransactionFlow = object : SignTransactionFlow(counterpartySession) {

            @Suspendable
            override fun checkTransaction(stx: SignedTransaction) {
                require(stx.inputs.size == 0) { "There should be no inputs for this transaction" }
                require(stx.tx.outputStates.size == 1) { "There should be one outputs for this transaction" }

                //val output = stx.tx.outputsOfType<TrackableState>().single()
                //require(output.status == ProductState.Status.Proposed) { "AcceptedLocalData status should be 'Proposed'" }
            }

        }
        val txId = subFlow(signTransactionFlow).id
        return subFlow(ReceiveFinalityFlow(counterpartySession, expectedTxId = txId))
    }
}

