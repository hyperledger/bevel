package com.supplychain.bevel

import co.paralleluniverse.fibers.Suspendable
import com.supplychain.bcc.contractstates.ContainerState
import com.supplychain.bcc.contractstates.ProductState
import com.supplychain.bcc.contractstates.SupplyChainContract
import com.supplychain.bcc.contractstates.TrackableState
import net.corda.core.contracts.StateAndRef
import net.corda.core.flows.*
import net.corda.core.identity.Party
import net.corda.core.node.services.queryBy
import net.corda.core.transactions.SignedTransaction
import net.corda.core.transactions.TransactionBuilder
import net.corda.core.utilities.ProgressTracker
import net.corda.core.identity.CordaX500Name
import java.util.*

/***************************************************************************
 * Definition of flow to claim ownership of TrackableState
 * @returns something
 ***************************************************************************/

@InitiatingFlow
@StartableByRPC
class UpdateContainer(val trackingID: UUID, val request: CreateContainerRequest) : FlowLogic<UUID>() {

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

        val inputs = getContainerContents(trackingID)
        // This is not ideal.....
        val outputs = inputs.map {
            if(it.state.data is ProductState) {
                (it.state.data as ProductState).copy(health = request.health)
            } else {
                (it.state.data as ContainerState).copy(health = request.health)
            }
        }

        val notary = serviceHub.networkMapCache.getNotary(CordaX500Name.parse("O=Notary Service,OU=Notary,L=London,C=GB"))
                    ?: throw IllegalStateException("Notary not found on network")    
        val txBuilder = TransactionBuilder(notary)
        for(input in inputs) {
            txBuilder.addInputState(input)
        }
        for(output in outputs) {
            txBuilder.addOutputState(output, SupplyChainContract.ID)
        }
        txBuilder.addCommand(SupplyChainContract.Commands.ClaimContainer(), outputs.first().participants.map { it.owningKey })

        progressTracker.currentStep = VERIFY_TRANSACTION
        txBuilder.verify(serviceHub)

        progressTracker.currentStep = SIGN_TRANSACTION
        val tx = serviceHub.signInitialTransaction(txBuilder)

        progressTracker.currentStep = COLLECT_COUNTERPARTY_SIG
        val participants = outputs[0].participants - ourIdentity
        val flowSessions = participants.map { initiateFlow(it as Party) }
        val stx = subFlow(CollectSignaturesFlow(tx, flowSessions))

        progressTracker.currentStep = FINALISE_TRANSACTION
        this.subFlow(FinalityFlow(stx, flowSessions, Companion.FINALISE_TRANSACTION.childProgressTracker()))

        return outputs[0].trackingID
    }

    private fun getContainerContents(containerId: UUID) : Collection<StateAndRef<TrackableState>> {
        val containers = serviceHub.vaultService.queryBy<ContainerState>().states
        val products = serviceHub.vaultService.queryBy<ProductState>().states

        val container = containers.find {
            it.state.data.trackingID == containerId
        } ?: throw IllegalArgumentException("No Container with ID $trackingID found.")

        val contents = mutableListOf<StateAndRef<TrackableState>>(container)

        for(id in container.state.data.contents) {
            val product = products.find {
                it.state.data.trackingID == id
            }
            if(product == null) {
                contents.addAll(getContainerContents(id))
            } else {
                contents.add(product)
            }
        }
        return contents
    }
}

@InitiatedBy(UpdateContainer::class)
open class UpdateContainerResponder(val counterpartySession: FlowSession) : FlowLogic<SignedTransaction>() {

    @Suspendable
    override fun call() : SignedTransaction {
        val signTransactionFlow = object : SignTransactionFlow(counterpartySession) {

            @Suspendable
            override fun checkTransaction(stx: SignedTransaction) {
                require(stx.inputs.size > 0) { "There should be one or more inputs for this transaction" }
                require(stx.tx.outputStates.size > 0) { "There should be one or more outputs for this transaction" }

                //val output = stx.tx.outputsOfType<TrackableState>().single()
            }

        }
        val txId = subFlow(signTransactionFlow).id
        return subFlow(ReceiveFinalityFlow(counterpartySession, expectedTxId = txId))    }
}