package com.acn.dlt.corda.doorman.storage.mongo

import com.mongodb.client.model.Filters
import com.mongodb.client.model.Indexes
import com.mongodb.reactivestreams.client.MongoClient
import com.mongodb.reactivestreams.client.MongoClients
import com.mongodb.reactivestreams.client.MongoCollection
import com.mongodb.reactivestreams.client.MongoDatabase
import io.bluebank.braid.core.logging.loggerFor
import com.acn.dlt.corda.doorman.storage.mongo.serlalisation.BsonId
import com.acn.dlt.corda.doorman.storage.mongo.serlalisation.JacksonCodecProvider
import com.acn.dlt.corda.doorman.storage.mongo.serlalisation.ObjectMapperFactory
import com.acn.dlt.corda.doorman.utils.NMSOptions
import io.vertx.core.Future
import org.bson.codecs.configuration.CodecRegistries
import org.bson.conversions.Bson
import org.reactivestreams.Publisher
import org.reactivestreams.Subscriber
import org.reactivestreams.Subscription
import java.io.File
import kotlin.reflect.KProperty
import kotlin.reflect.jvm.javaField


object MongoStorage {
  const val DEFAULT_DATABASE = "nms"
  val codecRegistry = CodecRegistries.fromRegistries(MongoClients.getDefaultCodecRegistry(),
    CodecRegistries.fromProviders(JacksonCodecProvider(ObjectMapperFactory.mapper)))!!

  fun connect(nmsOptions: NMSOptions): MongoClient {
    val connectionString = if (nmsOptions.mongoConnectionString == "embed") {
      startEmbeddedDatabase(nmsOptions)
    } else {
      nmsOptions.mongoConnectionString
    }

    return MongoClients.create(connectionString)
  }

  private fun startEmbeddedDatabase(nmsOptions: NMSOptions): String {
    return with(nmsOptions) {
      startEmbeddedDatabase(dbDirectory, true, mongodLocation).connectionString
    }
  }

  internal fun startEmbeddedDatabase(dbDirectory: File, isDaemon: Boolean, mongodLocation: String = ""): EmbeddedMongo {
    return EmbeddedMongo.create(File(dbDirectory, "mongo").absolutePath, mongodLocation, isDaemon)
  }
}

inline fun <reified T : Any> MongoDatabase.getTypedCollection(collection: String): MongoCollection<T> {
  return this.withCodecRegistry(MongoStorage.codecRegistry).getCollection(collection, T::class.java)
}

fun <T> Publisher<T>.toFuture(): Future<T> {
  val subscriber = SubscriberOnFuture<T>()
  this.subscribe(subscriber)
  return subscriber
}

class SubscriberOnFuture<T>(private val future: Future<T> = Future.future()) : Subscriber<T>, Future<T> by future {
  companion object {
    private val log = loggerFor<SubscriberOnFuture<*>>()
  }

  private var result: T? = null

  override fun onComplete() {
    try {
      when {
        future.isComplete -> {
          log.error("future is already complete with ${
          when (future.succeeded()) {
            true -> future.result()
            else -> future.cause() as Any
          }
          }")
        }
        else -> {
          future.complete(result)
        }
      }
    } catch (err: Throwable) {
      log.error("failed to complete future")
    }
  }

  override fun onSubscribe(s: Subscription?) {
    s?.request(1)
  }

  override fun onNext(t: T) {
    try {
      when {
        future.isComplete -> {
          log.error("future has already been completed")
        }
        result != null -> {
          log.error("already received one item $result")
        }
        else -> {
          result = t
        }
      }
    } catch (err: Throwable) {
      log.error("failed to complete future", err)
    }
  }

  override fun onError(t: Throwable?) {
    when {
      future.isComplete -> {
        log.error("future is already complete with ${
        when (future.succeeded()) {
          true -> future.result()
          else -> future.cause() as Any
        }
        }")
      }
      else -> {
        try {
          future.fail(t)
        } catch (err: Throwable) {
          log.error("failed to fail future", err)
        }
      }
    }
  }
}

infix fun <R> KProperty<R>.eq(key: R): Bson {
  val a = this.javaField!!.getDeclaredAnnotation(BsonId::class.java)
  return when (a) {
    null -> this.name
    else -> "_id"
  }.let { Filters.eq(it, key) }
}

enum class IndexType {
  HASHED
}

infix fun <R> IndexType.idx(property: KProperty<R>): Bson {
  return when(this) {
    IndexType.HASHED -> Indexes.hashed(property.name)
  }
}