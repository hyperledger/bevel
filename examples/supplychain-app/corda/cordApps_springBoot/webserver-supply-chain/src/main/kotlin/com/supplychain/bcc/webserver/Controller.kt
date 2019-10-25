package com.supplychain.bcc.webserver

import com.supplychain.bcc.contractstates.HistoryElement
import com.supplychain.bcc.contractstates.TrackableState
import net.corda.client.jackson.JacksonSupport
import net.corda.core.messaging.vaultQueryBy
import net.corda.core.node.services.Vault
import net.corda.core.node.services.vault.QueryCriteria
import org.slf4j.LoggerFactory
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.util.*


@RestController
@RequestMapping("/api/v1/")
class Controller(rpc: NodeRPCConnection) {

    companion object {
        private val logger = LoggerFactory.getLogger(RestController::class.java)
    }

    private val proxy = rpc.proxy
    private val mapper = JacksonSupport.createDefaultMapper(proxy)


    @GetMapping(value = ["/node-organization"], produces = [MediaType.APPLICATION_JSON_VALUE])
    private fun getNodeInfo() = ResponseEntity.ok(
        mapOf(
            "organization" to proxy.nodeInfo().legalIdentities.first().name.organisation
        )
    )
    @GetMapping(value = ["/node-organizationUnit"], produces = [MediaType.APPLICATION_JSON_VALUE])
    private fun getNodeOrganizationUnit() = ResponseEntity.ok(
            mapOf(
                    "organizationUnit" to proxy.nodeInfo().legalIdentities.first().name.organisationUnit
            )
    )

    @GetMapping(value = ["/{trackingID}/history"], produces = [MediaType.APPLICATION_JSON_VALUE])
    private fun getHistory(@PathVariable trackingID: UUID):String {
        val query = proxy.vaultQueryBy<TrackableState>(QueryCriteria.VaultQueryCriteria(Vault.StateStatus.ALL)).states
        val filtered = query.filter { it.state.data.trackingID == trackingID}

        return mapper.writeValueAsString(filtered.sortedByDescending { it.state.data.timestamp }.map{ HistoryElement(it.state.data.custodian, it.state.data.timestamp) }.distinct())
    }

    @GetMapping(value = ["/{trackingID}/scan"], produces = [MediaType.APPLICATION_JSON_VALUE])
    private fun scan(@PathVariable trackingID: UUID):String {
        val query = proxy.vaultQueryBy<TrackableState>().states
        val filtered = query.find { it.state.data.trackingID == trackingID}
        if(filtered != null ){
            if(filtered.state.data.custodian == proxy.nodeInfo().legalIdentities.first()){
                return  mapper.writeValueAsString(
                    mapOf(
                        "status" to "owned"
                ))
            }else{
                return  mapper.writeValueAsString(
                        mapOf(
                                "status" to "unowned"
                        ))
            }
        }else{
            return  mapper.writeValueAsString(
                    mapOf(
                            "status" to "new"
                    ))
        }


    }


}