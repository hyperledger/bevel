package com.acn.dlt.corda.doorman.serialisation

import com.fasterxml.jackson.databind.module.SimpleModule
import io.vertx.core.json.Json
import net.corda.client.jackson.JacksonSupport
import net.corda.client.rpc.internal.KryoClientSerializationScheme
import net.corda.core.identity.CordaX500Name
import net.corda.core.serialization.SerializationDefaults
import net.corda.core.serialization.SerializationFactory
import net.corda.core.serialization.deserialize
import net.corda.core.serialization.internal.SerializationEnvironmentImpl
import net.corda.core.serialization.internal._globalSerializationEnv
import net.corda.core.serialization.internal.nodeSerializationEnv
import net.corda.core.serialization.serialize
import net.corda.core.utilities.ByteSequence
import net.corda.core.utilities.loggerFor
import net.corda.nodeapi.internal.serialization.AMQP_P2P_CONTEXT
import net.corda.nodeapi.internal.serialization.SerializationFactoryImpl
import net.corda.nodeapi.internal.serialization.amqp.AMQPServerSerializationScheme
import java.security.PublicKey

class SerializationEnvironment {
  companion object {
    private val log = loggerFor<SerializationEnvironment>()

    init {
      initialiseJackson()
      initialiseSerialisationEnvironment()
    }

    fun init() {
      // implicit static causes one-time init of this class
    }

    @Suppress("DEPRECATION")
    private fun initialiseJackson() {
      val module = SimpleModule()
        .addDeserializer(CordaX500Name::class.java, JacksonSupport.CordaX500NameDeserializer)
        .addSerializer(CordaX500Name::class.java, JacksonSupport.CordaX500NameSerializer)
        .addSerializer(PublicKey::class.java, PublicKeySerializer())
        .addDeserializer(PublicKey::class.java, PublicKeyDeserializer())
      Json.mapper.registerModule(module)
      Json.prettyMapper.registerModule(module)
    }

    private fun initialiseSerialisationEnvironment() {
      if (_globalSerializationEnv.get() != null) {
        // special case when we're running in an integration test with a node
        return
      }

      if (nodeSerializationEnv == null) {
        val factory = NMSSerializationFactoryImpl("nms-factory").apply {
          registerScheme(KryoClientSerializationScheme())
          registerScheme(AMQPServerSerializationScheme(emptyList()))
        }
        val serializationEnv = SerializationEnvironmentImpl(
          factory,
          AMQP_P2P_CONTEXT
        )
        nodeSerializationEnv = serializationEnv
      } else {
        log.error("***** SERIALIZATION ENVIRONMENT ALREADY SET! ******")
      }
    }
  }

  private class NMSSerializationFactoryImpl(val name: String) : SerializationFactoryImpl()
}


fun <T : Any> T.serializeOnContext(): ByteSequence {
  return SerializationFactory.defaultFactory.withCurrentContext(SerializationDefaults.P2P_CONTEXT) {
    this.serialize()
  }
}

inline fun <reified T : Any> ByteSequence.deserializeOnContext(): T {
  return SerializationFactory.defaultFactory.withCurrentContext(SerializationDefaults.P2P_CONTEXT) {
    this.deserialize()
  }
}

inline fun <reified T : Any> ByteArray.deserializeOnContext(): T {
  return SerializationFactory.defaultFactory.withCurrentContext(SerializationDefaults.P2P_CONTEXT) {
    this.deserialize()
  }
}

