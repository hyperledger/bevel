package com.supplychain.bcc.contractstates

import net.corda.core.identity.Party

data class HistoryElement(
        val party: Party,
        val time: Long
)