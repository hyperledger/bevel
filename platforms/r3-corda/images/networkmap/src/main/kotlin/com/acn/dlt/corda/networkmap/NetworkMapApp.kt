package com.acn.dlt.corda.networkmap

import io.bluebank.braid.core.logging.loggerFor
import com.acn.dlt.corda.networkmap.service.NetworkMapService
import com.acn.dlt.corda.networkmap.utils.NMSOptions
import com.acn.dlt.corda.networkmap.utils.NMSOptionsParser
import kotlin.system.exitProcess


open class NetworkMapApp {
  companion object {
    private val logger = loggerFor<NetworkMapApp>()

    @JvmStatic
    fun main(args: Array<String>) {
      NMSOptionsParser().apply {
        if (args.contains("--help")) {
          printHelp()
          return
        }
        println("starting networkmap with the following options")
        printOptions()
        bootstrapNMS()
      }
    }

    private fun NMSOptionsParser.bootstrapNMS() {
      NMSOptions.parse(this).apply {
        if (truststore != null && !truststore.exists()) {
          println("failed to find truststore ${truststore.path}")
          exitProcess(-1)
        }
        NetworkMapService(this).startup().setHandler {
          if (it.failed()) {
            logger.error("failed to complete setup", it.cause())
          } else {
            logger.info("started")
          }
        }
      }
    }
  }
}
