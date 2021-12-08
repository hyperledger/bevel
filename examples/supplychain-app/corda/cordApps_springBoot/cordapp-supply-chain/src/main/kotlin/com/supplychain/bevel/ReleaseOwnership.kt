package com.supplychain.bevel

import co.paralleluniverse.fibers.Suspendable
import net.corda.core.flows.*
import net.corda.core.utilities.ProgressTracker

/*****************************************************************************
* Definition of flow to release ownership of  ProductState or ContainerState
* @returns something
*****************************************************************************/

@InitiatingFlow
@StartableByRPC
class ReleaseOwnership : FlowLogic<Unit>() {
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
    override fun call() {
        // Initiator flow logic goes here.
    }
}

@InitiatedBy(ReleaseOwnership::class)
open class ReleaseOwnershipResponder(val counterpartySession: FlowSession) : FlowLogic<Unit>() {
    @Suspendable
    override fun call() {
        // Responder flow logic goes here.
    }
}


