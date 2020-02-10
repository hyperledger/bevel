package com.acn.dlt.corda.doorman.utils

import com.acn.dlt.corda.doorman.storage.file.NetworkParameterInputsStorage
import net.corda.core.node.services.AttachmentId

fun String.toWhiteList(): Map<String, List<AttachmentId>> {
  return this.lines().parseToWhitelistPairs().groupBy({it -> it.first}, {it -> it.second})
}

fun List<String>.parseToWhitelistPairs(): List<Pair<String, AttachmentId>> {
  return map { it.trim() }
    .filter { it.isNotEmpty() }
    .map { row -> row.split(":") } // simple parsing for the whitelist
    .mapIndexed { index, row ->
      if (row.size != 2) {
        NetworkParameterInputsStorage.log.error("malformed whitelist entry on line $index - expected <class>:<attachment id>")
        null
      } else {
        row
      }
    }
    .mapNotNull {
      // if we have an attachment id, try to parse it
      it?.let {
        try {
          it[0] to AttachmentId.parse(it[1])
        } catch (err: Throwable) {
          NetworkParameterInputsStorage.log.error("failed to parse attachment nodeKey", err)
          null
        }
      }
    }
}

fun List<Pair<String, AttachmentId>>.toWhitelistText(): String {
  return this.joinToString("\n") { it.first + ':' + it.second.toString() }
}


fun String.toWhitelistPairs(): List<Pair<String, AttachmentId>> {
  return this.lines().parseToWhitelistPairs()
}
