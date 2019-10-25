package com.supplychain.bcc.contractstates

import net.corda.core.contracts.*
import net.corda.core.identity.Party
import java.util.*

@BelongsToContract(SupplyChainContract::class)
data class ContainerState(
        val health: String?, //TODO: Figure out how to handle health
        val misc: Map<String, Any>,
        override val custodian: Party,
        override val trackingID: UUID,
        override val timestamp: Long,
        override val containerID: UUID? = null,
        val contents: MutableList<UUID> = mutableListOf(),
        override val linearId: UniqueIdentifier = UniqueIdentifier(),
        override val participants: List<Party> = listOf() ) : TrackableState {

    override fun withNewTracking(custodian: Party, trackingID: UUID, timestamp: Long, containerID: UUID?) : ContainerState {
        return ContainerState(
                this.health,
                this.misc,
                custodian,
                trackingID,
                timestamp,
                containerID,
                this.contents.toMutableList(),
                this.linearId,
                this.participants
        )
    }

    fun withNewProduct(trackingID: UUID) : ContainerState {
        val newContents = this.contents.toMutableList()
        newContents.add(trackingID)

        return this.copy(contents = newContents)
    }

    fun withRemovedProduct(trackingID: UUID) : ContainerState {
        val newContents = this.contents.toMutableList()
        newContents.remove(trackingID)

        return this.copy(contents = newContents)
    }

}
