package com.supplychain.bcc.contractstates

import net.corda.core.contracts.LinearState
import net.corda.core.identity.Party
import java.util.*


interface TrackableState : LinearState {
    val custodian: Party
    val trackingID: UUID
    val timestamp: Long
    val containerID: UUID?

    fun withNewTracking(
            custodian: Party = this.custodian,
            trackingID: UUID = this.trackingID,
            timestamp: Long = this.timestamp,
            containerID: UUID? = this.containerID) : TrackableState
}

