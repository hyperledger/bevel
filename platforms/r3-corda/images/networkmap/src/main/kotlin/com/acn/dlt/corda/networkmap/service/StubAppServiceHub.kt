package com.acn.dlt.corda.networkmap.service

import net.corda.core.contracts.*
import net.corda.core.cordapp.CordappProvider
import net.corda.core.crypto.entropyToKeyPair
import net.corda.core.flows.FlowLogic
import net.corda.core.identity.CordaX500Name
import net.corda.core.identity.Party
import net.corda.core.identity.PartyAndCertificate
import net.corda.core.messaging.FlowHandle
import net.corda.core.messaging.FlowProgressHandle
import net.corda.core.node.AppServiceHub
import net.corda.core.node.NetworkParameters
import net.corda.core.node.NodeInfo
import net.corda.core.node.StatesToRecord
import net.corda.core.node.services.*
import net.corda.core.serialization.SerializeAsToken
import net.corda.core.transactions.SignedTransaction
import net.corda.core.utilities.NetworkHostAndPort
import net.corda.nodeapi.internal.DEV_INTERMEDIATE_CA
import net.corda.nodeapi.internal.DEV_ROOT_CA
import net.corda.nodeapi.internal.createDevNodeCa
import net.corda.nodeapi.internal.crypto.CertificateAndKeyPair
import net.corda.nodeapi.internal.crypto.CertificateType
import net.corda.nodeapi.internal.crypto.X509Utilities
import java.math.BigInteger
import java.security.cert.X509Certificate
import java.sql.Connection
import java.time.Clock
import java.util.function.Consumer
import javax.persistence.EntityManager

/**
 * A stub class to simulate the service hub - we need this for Braid Corda
 * Technically braid-corda's core could be moved to core
 */
class StubAppServiceHub() : AppServiceHub {
  companion object {
    private val NAME = CordaX500Name("Network Map Service", "London", "GB")
    private val partyAndCertificate = getTestPartyAndCertificate(Party(NAME, entropyToKeyPair(BigInteger.valueOf(40)).public))
    private fun getTestPartyAndCertificate(party: Party): PartyAndCertificate {
      val trustRoot: X509Certificate = DEV_ROOT_CA.certificate
      val intermediate: CertificateAndKeyPair = DEV_INTERMEDIATE_CA

      val (nodeCaCert, nodeCaKeyPair) = createDevNodeCa(intermediate, party.name)

      val identityCert = X509Utilities.createCertificate(
        CertificateType.LEGAL_IDENTITY,
        nodeCaCert,
        nodeCaKeyPair,
        party.name.x500Principal,
        party.owningKey)

      val certPath = X509Utilities.buildCertPath(identityCert, nodeCaCert, intermediate.certificate, trustRoot)
      return PartyAndCertificate(certPath)
    }
  }

  override val attachments: AttachmentStorage
    get() = TODO("not implemented") //To change initializer of created properties use File | Settings | File Templates.
  override val clock: Clock
    get() = TODO("not implemented") //To change initializer of created properties use File | Settings | File Templates.
  override val contractUpgradeService: ContractUpgradeService
    get() = TODO("not implemented") //To change initializer of created properties use File | Settings | File Templates.
  override val cordappProvider: CordappProvider
    get() = TODO("not implemented") //To change initializer of created properties use File | Settings | File Templates.
  override val identityService: IdentityService
    get() = TODO("not implemented") //To change initializer of created properties use File | Settings | File Templates.
  override val keyManagementService: KeyManagementService
    get() = TODO("not implemented") //To change initializer of created properties use File | Settings | File Templates.
  override val myInfo: NodeInfo
    get() = NodeInfo(listOf(NetworkHostAndPort("localhost", 10001)), listOf(partyAndCertificate), 3, 1)
  override val networkMapCache: NetworkMapCache
    get() = TODO("not implemented") //To change initializer of created properties use File | Settings | File Templates.
  override val networkParameters: NetworkParameters
    get() = TODO("not implemented") //To change initializer of created properties use File | Settings | File Templates.
  override val transactionVerifierService: TransactionVerifierService
    get() = TODO("not implemented") //To change initializer of created properties use File | Settings | File Templates.
  override val validatedTransactions: TransactionStorage
    get() = TODO("not implemented") //To change initializer of created properties use File | Settings | File Templates.
  override val vaultService: VaultService
    get() = TODO("not implemented") //To change initializer of created properties use File | Settings | File Templates
  override val networkParametersService: NetworkParametersService
    get() = TODO("not implemented")

  override fun <T : SerializeAsToken> cordaService(type: Class<T>): T {
    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
  }

  override fun jdbcSession(): Connection {
    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
  }

  override fun loadState(stateRef: StateRef): TransactionState<*> {
    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
  }

  override fun loadStates(stateRefs: Set<StateRef>): Set<StateAndRef<ContractState>> {
    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
  }

  override fun recordTransactions(statesToRecord: StatesToRecord, txs: Iterable<SignedTransaction>) {
    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
  }

  override fun registerUnloadHandler(runOnStop: () -> Unit) {
  }

  override fun <T> startFlow(flow: FlowLogic<T>): FlowHandle<T> {
    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
  }

  override fun <T> startTrackedFlow(flow: FlowLogic<T>): FlowProgressHandle<T> {
    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
  }

  override fun loadContractAttachment(stateRef: StateRef): Attachment {
    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
  }

  override fun withEntityManager(block: Consumer<EntityManager>) {
    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
  }

  override fun <T : Any> withEntityManager(block: EntityManager.() -> T): T {
    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
  }
}