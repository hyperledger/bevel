package com.supplychain.bcc.contractstates

import net.corda.core.contracts.*
import net.corda.core.transactions.LedgerTransaction
import java.security.PublicKey

// ************
// * Contract *
// ************
class SupplyChainContract : Contract {
    companion object {
        // Used to identify our contract when building a transaction.
        const val ID = "com.supplychain.bcc.contractstates.SupplyChainContract"
    }

    // Used to indicate the transaction's intent.
    interface Commands : CommandData {
        class CreateProduct : TypeOnlyCommandData(), Commands
        class ClaimTrackable : TypeOnlyCommandData(), Commands
        class ClaimContainer : TypeOnlyCommandData(), Commands
        class UpdateProduct : TypeOnlyCommandData(), Commands
        class UpdateContainer : TypeOnlyCommandData(), Commands
        class CreateContainer : TypeOnlyCommandData(), Commands
        class PackContainer : TypeOnlyCommandData(), Commands
        class UnpackContainer : TypeOnlyCommandData(), Commands
        class SellProduct : TypeOnlyCommandData(), Commands //TODO: Low priority
        class Recall : TypeOnlyCommandData(), Commands //TODO:Nice to have

    }

    // A transaction is valid if the verify() function of the contract of all the transaction's input and output states
    // does not throw an exception.
    override fun verify(tx: LedgerTransaction) {
        // Verification logic goes here.
        val txcommand = tx.commands.requireSingleCommand<Commands>()

        when (txcommand.value) {
            is Commands.CreateProduct -> requireThat {
                val output = tx.outputsOfType<ProductState>().single()
                val inputLength = tx.inputs.size
                "There should be no inputs consumed" using (inputLength == 0)
                "Custodian ${output.custodian.owningKey} must be a participant" using (output.custodian in output.participants)
                "Product cannot be just created and already have a container" using (output.containerID === null)
                "Cannot have a Product generated as sold" using (output.sold == false)
                "Cannot have a Product generated as recalled" using (output.recalled == false)



                //Insert other verification logic here

            }
            is Commands.ClaimTrackable -> requireThat {
                val output = tx.outputsOfType<TrackableState>().single()
                val input = tx.inputsOfType<TrackableState>().single()
                val requiredSigners = txcommand.signers
                "There should be one and only one input consumed" using (tx.inputs.size == 1)
                "Custodian ${output.custodian.owningKey} must be a participant" using (output.custodian in output.participants)
                "All participants must sign" using (requiredSigners.containsAll<PublicKey>(input.participants.map{it.owningKey}))
                "Only custodian should change" using (input == output.withNewTracking(custodian = input.custodian, timestamp = input.timestamp))
                "Must not be in a container" using (input.containerID == null)
                "Custodian must change" using (input.custodian !== output.custodian)
            }
            is Commands.ClaimContainer -> requireThat {
                val outputs = tx.outputsOfType<TrackableState>()
                val inputs = tx.inputsOfType<TrackableState>()
                "Input custodians should match" using (inputs.map{it.custodian}.distinct().size == 1)
                "Output custodians should match" using (outputs.map{it.custodian}.distinct().size == 1)
                "Custodian must be different" using (inputs.map{it.custodian}.distinct() != outputs.map{it.custodian}.distinct() )
                //"Custodian ${output.custodian.owningKey} must be a participant" using (output.custodian in output.participants)
            }
            is Commands.UpdateProduct -> requireThat {

            }
            is Commands.UpdateContainer -> requireThat {

            }
            is Commands.CreateContainer -> requireThat {
                val output = tx.outputsOfType<ContainerState>().single()
                val requiredSigner = txcommand.signers
                val inputLength = tx.inputs.size
                "There should be no inputs consumed" using (inputLength == 0)
                "Custodian ${output.custodian.owningKey} must be the current signer ${requiredSigner}" using ((output.custodian.owningKey) in requiredSigner )
                "Custodian ${output.custodian.owningKey} must be a participant" using (output.custodian in output.participants)
                "Container cannot be just created and already have a container" using (output.containerID === null)

                //Insert other verification logic here

            }
            is Commands.PackContainer -> requireThat {
                val inputs = tx.inputsOfType<TrackableState>()
                val outputs = tx.outputsOfType<TrackableState>()
                "Two inputs should be consumed" using (inputs.size == 2)
                "Two outputs should be generated" using (outputs.size == 2)
                "Custodian of inputs should be the same" using (inputs.first().custodian == inputs.last().custodian)
                "Custodian of outputs should be the same" using (outputs.first().custodian == outputs.last().custodian)
                "Neither input should be in a container" using (inputs.map { it.containerID } == listOf(null , null)) //no idea if this will work
            }


            is Commands.UnpackContainer -> requireThat {
                val inputs = tx.inputsOfType<TrackableState>()
                val outputs = tx.outputsOfType<TrackableState>()
                "Two inputs should be consumed" using (inputs.size == 2)
                "Two outputs should be generated" using (outputs.size == 2)
                "Custodian of inputs should be the same" using (inputs.first().custodian == inputs.last().custodian)
                "Custodian of outputs should be the same" using (outputs.first().custodian == outputs.last().custodian)
                "Neither output should be in a container" using (outputs.map { it.containerID } == listOf(null,null)) //no idea if this will work


            }
            is Commands.SellProduct -> requireThat {

            }
            is Commands.Recall -> requireThat {

            }

        }
    }


}
