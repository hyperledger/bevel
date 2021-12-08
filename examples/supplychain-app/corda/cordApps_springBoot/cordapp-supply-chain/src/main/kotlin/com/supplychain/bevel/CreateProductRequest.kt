package com.supplychain.bevel

import net.corda.core.serialization.CordaSerializable
import java.util.*

@CordaSerializable
data class CreateProductRequest(
    val productName: String,
    val health: String?,
    val misc: Map<String,Any>,
    val trackingID: UUID,
    val counterparties: List<String>
)