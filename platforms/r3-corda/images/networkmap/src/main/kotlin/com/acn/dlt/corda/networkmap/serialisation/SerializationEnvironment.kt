package com.acn.dlt.corda.networkmap.serialisation

import com.fasterxml.jackson.databind.module.SimpleModule
import io.bluebank.braid.corda.serialisation.BraidCordaJacksonInit
import com.acn.dlt.corda.networkmap.service.NetworkMapServiceProcessor
import io.vertx.core.json.Json
import net.corda.client.jackson.JacksonSupport
import net.corda.core.identity.CordaX500Name
import net.corda.core.node.NetworkParameters
import net.corda.core.serialization.SerializationDefaults
import net.corda.core.serialization.SerializationFactory
import net.corda.core.serialization.deserialize
import net.corda.core.serialization.internal.nodeSerializationEnv
import net.corda.core.serialization.serialize
import net.corda.core.utilities.ByteSequence
import net.corda.core.utilities.loggerFor
import net.corda.core.utilities.sequence
import net.corda.node.serialization.amqp.AMQPServerSerializationScheme
import net.corda.serialization.internal.AMQP_P2P_CONTEXT
import net.corda.serialization.internal.SerializationFactoryImpl
import java.security.PublicKey
import java.sql.Blob

open class SerializationEnvironment {
  companion object {
    private val log = loggerFor<SerializationEnvironment>()

    fun init() {
      BraidCordaJacksonInit.init()
      SerializationEnvironment().setup()
    }

    @Suppress("DEPRECATION")
    private fun initialiseJackson() {
      val module = SimpleModule()
        .addDeserializer(CordaX500Name::class.java, JacksonSupport.CordaX500NameDeserializer)
        .addSerializer(CordaX500Name::class.java, JacksonSupport.CordaX500NameSerializer)
        .addSerializer(PublicKey::class.java, PublicKeySerializer())
        .addDeserializer(PublicKey::class.java, PublicKeyDeserializer())
	      .setMixInAnnotation(NetworkParameters::class.java, NetworkParametersMixin::class.java)
      Json.mapper.registerModule(module)
      Json.prettyMapper.registerModule(module)
    }
  }

  private class NMSSerializationFactoryImpl(val name: String) : SerializationFactoryImpl()

  fun setup() {
    initialiseJackson()
    initialiseSerialisationEnvironment()
  }

  protected open fun initialiseSerialisationEnvironment() {
    val serializationEnv = createSerializationEnvironment()
    if (nodeSerializationEnv == null) {
      log.info("setting node serialisation env")
      nodeSerializationEnv = serializationEnv
    } else {
      log.error("***** SERIALIZATION ENVIRONMENT ALREADY SET! ******")
    }
  }

  protected open fun createSerializationEnvironment(): net.corda.core.serialization.internal.SerializationEnvironment {
    val factory = NMSSerializationFactoryImpl("nms-factory").apply {
      registerScheme(AMQPServerSerializationScheme(emptyList()))
    }
    return net.corda.core.serialization.internal.SerializationEnvironment.with(
      serializationFactory = factory,
      p2pContext = AMQP_P2P_CONTEXT
    )
  }
}

fun <T : Any> T.serializeOnContext(): ByteSequence {
  return SerializationFactory.defaultFactory.withCurrentContext(SerializationDefaults.P2P_CONTEXT) {
    this.serialize()
  }
}

inline fun <reified T : Any> ByteArray.deserializeOnContext(): T {
  return SerializationFactory.defaultFactory.withCurrentContext(SerializationDefaults.P2P_CONTEXT) {
    this.deserialize()
  }
}

fun <T : Any> Blob.deserializeOnContext(clazz : Class<T>): T {
  val array = this.getBytes(1, this.length().toInt())
  return SerializationFactory.defaultFactory.deserialize(array.sequence(), clazz, SerializationDefaults.P2P_CONTEXT)
}
