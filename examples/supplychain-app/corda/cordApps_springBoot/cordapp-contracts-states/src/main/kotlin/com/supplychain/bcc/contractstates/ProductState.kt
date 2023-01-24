package com.supplychain.bcc.contractstates

import net.corda.core.contracts.*
import net.corda.core.identity.Party
import java.util.*

// *********
// * State *
// *********
@BelongsToContract(SupplyChainContract::class)
data class ProductState(
        val productName: String,
        val health: String?, //TODO: Figure out how to handle health
        val sold: Boolean,
        val recalled: Boolean,
        val misc: Map<String,Any>,
        override val custodian: Party ,
        override val trackingID: UUID,
        override val timestamp: Long,
        override val containerID: UUID? = null,
        override val linearId: UniqueIdentifier = UniqueIdentifier(),
        override val participants: List<Party> = listOf() ) : TrackableState {

    override fun withNewTracking(custodian: Party, trackingID: UUID, timestamp: Long, containerID: UUID?) : ProductState {
        return ProductState(
                this.productName,
                this.health,
                this.sold,
                this.recalled,
                this.misc,
                custodian,
                trackingID,
                timestamp,
                containerID,
                this.linearId,
                this.participants
        )
    }

}

