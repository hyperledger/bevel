package com.acn.dlt.corda.networkmap.storage.mongo

import com.mongodb.client.model.Filters
import com.mongodb.client.model.ReplaceOptions
import com.mongodb.reactivestreams.client.MongoClient
import io.bluebank.braid.core.async.mapUnit
import io.bluebank.braid.core.async.toFuture
import io.bluebank.braid.core.logging.loggerFor
import com.acn.dlt.corda.networkmap.storage.Storage
import com.acn.dlt.corda.networkmap.storage.file.TextStorage
import com.acn.dlt.corda.networkmap.storage.mongo.rx.toObservable
import com.acn.dlt.corda.networkmap.storage.mongo.serlalisation.BsonId
import com.acn.dlt.corda.networkmap.utils.*
import io.vertx.core.Future
import io.vertx.core.impl.NoStackTraceThrowable
import io.vertx.ext.web.RoutingContext
import java.time.Duration

class MongoTextStorage(mongoClient: MongoClient,
                       database: String = MongoStorage.DEFAULT_DATABASE,
                       collection: String = "etc") : Storage<String> {
  companion object {
    private val log = loggerFor<MongoTextStorage>()
  }

  private val collection = mongoClient.getDatabase(database).getTypedCollection<KeyValue>(collection)

  override fun clear(): Future<Unit> = collection.drop().toFuture().mapUnit()

  override fun put(key: String, value: String): Future<Unit> = collection
    .replaceOne(KeyValue::key eq key, KeyValue(key, value), ReplaceOptions().upsert(true))
    .toFuture().mapUnit()

  fun put(keyValue: KeyValue): Future<Unit> = collection
    .replaceOne(KeyValue::key eq keyValue.key, keyValue, ReplaceOptions().upsert(true))
    .toFuture().mapUnit()

  override fun get(key: String): Future<String> = collection.find(KeyValue::key eq key)
    .first()
    .toFuture()
    .map {
      if (it == null) throw NoStackTraceThrowable("did not find value for key $key")
      it.value
    }

  fun migrate(textStorage: TextStorage): Future<Unit> {
    return textStorage.getAll()
      .map { it.map { KeyValue(it.key, it.value) } }
      .compose {
        if (it.isEmpty()) {
          log.info("text storage is empty; no migration required")
          Future.succeededFuture(Unit)
        } else {
          log.info("migrating text storage to mongodb")
          it.map {
            log.info("migrating $it")
            put(it)
          }.all()
            .compose {
              log.info("clearing file-base text storage")
              textStorage.clear()
            }
            .onSuccess { log.info("text storage migration done") }
        }
      }
  }

  override fun getOrNull(key: String): Future<String?> {
    return collection.find(KeyValue::key eq key)
      .first()
      .toFuture()
      .map {
        it?.value
      }
  }

  override fun getKeys(): Future<List<String>> {
    return collection
      .find()
      .toFuture { key }
  }
  
  override fun getAll(): Future<Map<String, String>> {
    return collection
      .find()
      .toFuture({ key }, { value })
  }

  override fun getAll(keys: List<String>): Future<Map<String, String>> {
    return collection
      .find()
      .filter(KeyValue::key `in` keys)
      .toFuture({ key }, { value })
  }

  override fun delete(key: String): Future<Unit> {
    return collection.deleteOne(Filters.eq(KeyValue::key.name, key))
      .toFuture()
      .mapUnit()
  }

  override fun exists(key: String): Future<Boolean> {
    return collection.countDocuments(Filters.eq(KeyValue::key.name, key))
      .toFuture()
      .map {
        it > 0
      }
  }

  override fun serve(key: String, routingContext: RoutingContext, cacheTimeout: Duration) {
    get(key)
      .onSuccess {
        routingContext.response().setCacheControl(cacheTimeout).end(it)
      }
      .catch {
        routingContext.end(it)
      }
  }
  
  override fun size(): Future<Int> {
    return collection.find()
      .toObservable()
      .count()
      .toFuture()
  }
  
  override fun getPage(page: Int, pageSize: Int): Future<Map<String, String>> {
    return collection
      .find().skip(pageSize * (page - 1)).limit(pageSize)
      .toFuture({ key }, { value })
  }

  data class KeyValue(@BsonId val key: String, val value: String)
}