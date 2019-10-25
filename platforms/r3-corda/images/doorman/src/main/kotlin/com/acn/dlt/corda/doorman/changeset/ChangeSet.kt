package com.acn.dlt.corda.doorman.changeset
import io.vertx.core.json.Json
import net.corda.core.crypto.SecureHash
import net.corda.core.node.NetworkParameters
import net.corda.core.node.NotaryInfo
import net.corda.core.node.services.AttachmentId
import net.corda.core.serialization.serialize
import java.time.Instant
import java.util.function.Function

fun changeSet(vararg change: Change): (NetworkParameters) -> NetworkParameters {
  return changeSet(change.asSequence())
}

fun changeSet(change: Collection<Change>): (NetworkParameters) -> NetworkParameters {
  return changeSet(change.asSequence())
}

fun changeSet(changes: Sequence<Change>): (NetworkParameters) -> NetworkParameters {
  return { np: NetworkParameters ->
    changes.fold(np) { acc, change -> change.apply(acc) }.let { it.copy(epoch = it.epoch + 1) }
  }
}

sealed class Change : Function<NetworkParameters, NetworkParameters> {
  val description get() = "${this.javaClass.simpleName!!}: ${Json.encode(this)}"

  data class AddNotary(val notary: NotaryInfo) : Change() {
    override fun apply(networkParameters: NetworkParameters) =
      networkParameters.copy(
        notaries = networkParameters.notaries.toMutableSet().apply { add(notary) }.toList(),
        modifiedTime = Instant.now()
      )
  }

  data class RemoveNotary(val nameHash: SecureHash) : Change() {
    override fun apply(networkParameters: NetworkParameters) =
      networkParameters.copy(
        notaries = networkParameters.notaries.filter { it.identity.name.serialize().hash != nameHash },
        modifiedTime = Instant.now()
      )
  }

  data class ReplaceNotaries(val notaries: List<NotaryInfo>) : Change() {
    override fun apply(networkParameters: NetworkParameters) =
      networkParameters.copy(
        notaries = notaries.distinct(),
        modifiedTime = Instant.now()
      )
  }

  object ClearNotaries : Change() {
    override fun apply(networkParameters: NetworkParameters) =
      networkParameters.copy(
        notaries = emptyList(),
        modifiedTime = Instant.now()
      )
  }

  data class AppendWhiteList(val whitelist: Map<String, List<AttachmentId>>) : Change() {
    override fun apply(networkParameters: NetworkParameters): NetworkParameters {
      val flattenedOldList = networkParameters.whitelistedContractImplementations.flatMap { entry -> entry.value.map { attachmentId -> entry.key to attachmentId} }
      val flattenedNewList = whitelist.flatMap { entry -> entry.value.map { attachmentId -> entry.key to attachmentId} }
      val joined = (flattenedOldList + flattenedNewList).distinct().groupBy({it.first}, {it.second})
      return networkParameters.copy(
        whitelistedContractImplementations = joined,
        modifiedTime = Instant.now()
      )
    }
  }

  data class ReplaceWhiteList(val whitelist: Map<String, List<AttachmentId>>) : Change() {
    override fun apply(networkParameters: NetworkParameters) = networkParameters.copy(
      whitelistedContractImplementations = whitelist,
      modifiedTime = Instant.now()
    )
  }

  object ClearWhiteList : Change() {
    override fun apply(t: NetworkParameters) = t.copy(
      whitelistedContractImplementations = emptyMap(),
      modifiedTime = Instant.now()
    )
  }
}