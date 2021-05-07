package com.acn.dlt.corda.networkmap.storage.mongo

import com.mongodb.ConnectionString
import com.mongodb.MongoClientSettings
import com.mongodb.client.model.Filters
import com.mongodb.client.model.Indexes
import com.mongodb.reactivestreams.client.*
import io.bluebank.braid.core.logging.loggerFor
import com.acn.dlt.corda.networkmap.storage.mongo.rx.toObservable
import com.acn.dlt.corda.networkmap.storage.mongo.serlalisation.BsonId
import com.acn.dlt.corda.networkmap.storage.mongo.serlalisation.JacksonCodecProvider
import com.acn.dlt.corda.networkmap.storage.mongo.serlalisation.ObjectMapperFactory
import com.acn.dlt.corda.networkmap.utils.NMSOptions
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

    val settings = MongoClientSettings.builder()
      .applyConnectionString(ConnectionString(connectionString))
      .applyToConnectionPoolSettings {
        it.maxSize(10)
      }.build()

    return MongoClients.create(settings)
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
    private val ignoreClasses = setOf(SubscriberOnFuture::class.java.name, "com.acn.dlt.corda.networkmap.storage.mongo.MongoStorageKt", Thread::class.java.name)
  }

  private var result: T? = null
  private val stack = Thread.currentThread().stackTrace.first { !ignoreClasses.contains(it.className) }

  override fun onComplete() {
    try {
      when {
        future.isComplete -> {
          log.error("future is already complete with ${
          when (future.succeeded()) {
            true -> future.result()
            else -> future.cause() as Any
          }
          } execute from $stack")
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
          log.error("future has already been completed executed from stack $stack")
        }
        result != null -> {
          log.error("already received one item $result for future executed from stack $stack")
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
        } for future executed from $stack")
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

infix fun <R> KProperty<R>.eq(value: R) = Filters.eq(bsonName, value)
infix fun <R> KProperty<R>.`in`(values: Iterable<R>) = Filters.`in`(bsonName, values)

val <R> KProperty<R>.bsonName get() : String {
  val a = this.javaField!!.getDeclaredAnnotation(BsonId::class.java)
  return when (a) {
    null -> this.name
    else -> "_id"
  }
}

enum class IndexType {
  HASHED
}

infix fun <R> IndexType.idx(property: KProperty<R>): Bson {
  return when (this) {
    IndexType.HASHED -> Indexes.hashed(property.name)
  }
}

inline fun <reified TResult, reified Key, reified Value> FindPublisher<TResult>.toFuture(crossinline keyExtractor: TResult.() -> Key, crossinline valueExtractor: TResult.() -> Value) : Future<Map<Key, Value>> {
  val map = mutableMapOf<Key, Value>()
  val result = Future.future<Map<Key, Value>>()

  this.toObservable()
    .subscribe(object : rx.Subscriber<TResult>(), Subscriber<TResult> {
      override fun onCompleted() {
        result.complete(map)
      }

      override fun onComplete() {
        result.complete(map)
      }

      override fun onSubscribe(subscription: Subscription?) {}

      override fun onNext(result: TResult) {
        map[keyExtractor(result)] = valueExtractor(result)
      }

      override fun onError(exception: Throwable?) {
        result.fail(exception)
      }
    })
  return result
}

inline fun <reified TResult, reified Value> FindPublisher<TResult>.toFuture(crossinline valueExtractor: TResult.() -> Value) : Future<List<Value>> {
  val items = mutableListOf<Value>()
  val result = Future.future<List<Value>>()

  this.toObservable()
    .subscribe(object : rx.Subscriber<TResult>(), Subscriber<TResult> {
      override fun onCompleted() {
        result.complete(items)
      }

      override fun onComplete() {
        result.complete(items)
      }

      override fun onSubscribe(subscription: Subscription?) {}

      override fun onNext(result: TResult) {
        items.add(valueExtractor(result))
      }

      override fun onError(exception: Throwable?) {
        result.fail(exception)
      }
    })
  return result
}
