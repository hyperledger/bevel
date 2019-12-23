package com.supplychain.bcc

import net.corda.core.serialization.CordaSerializable
import java.util.*

@CordaSerializable
data class Contents(
    val contents: UUID

)