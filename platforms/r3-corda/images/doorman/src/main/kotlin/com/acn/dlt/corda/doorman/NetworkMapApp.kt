package com.acn.dlt.corda.doorman

import io.bluebank.braid.core.logging.loggerFor
import com.acn.dlt.corda.doorman.service.CertificateManagerConfig
import com.acn.dlt.corda.doorman.service.NetworkMapService
import com.acn.dlt.corda.doorman.storage.mongo.MongoStorage
import com.acn.dlt.corda.doorman.utils.LogInitialiser
import com.acn.dlt.corda.doorman.utils.NMSOptions
import kotlin.system.exitProcess



open class NetworkMapApp {
    companion object {
        private val logger = loggerFor<NetworkMapApp>()

        @JvmStatic
        fun main(args: Array<String>) {
            LogInitialiser.init()
            NMSOptions().apply {
                if (args.contains("--help")) {
                    printHelp()
                    return
                }
                println("starting doorman with the following options")
                printOptions()
                bootstrapNMS()
            }
        }

        private fun NMSOptions.bootstrapNMS() {
            val mongoClient = MongoStorage.connect(this)
            NetworkMapService(
                    dbDirectory = dbDirectory,
                    user = user,
                    port = port,
                    cacheTimeout = cacheTimeout,
                    paramUpdateDelay = paramUpdateDelay,
                    networkMapQueuedUpdateDelay = networkMapUpdateDelay,
                    tls = tls,
                    certPath = certPath,
                    keyPath = keyPath,
                    hostname = hostname,
                    webRoot = webRoot,
                    certificateManagerConfig = CertificateManagerConfig(
                            root = root,
                            doorManEnabled = enableDoorman
                    ),
                    mongoClient = mongoClient,
                    mongoDatabase = mongodDatabase
            ).startup().setHandler {
                if (it.failed()) {
                    logger.error("failed to complete setup", it.cause())
                } else {
                    logger.info("started")
                }
            }
        }
    }
}
