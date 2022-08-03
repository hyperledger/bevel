package com.acn.dlt.corda.doorman.storage

import io.vertx.core.Future
import io.vertx.ext.web.RoutingContext
import java.time.Duration

interface Storage<T> {
  fun clear(): Future<Unit>
  fun put(key: String, value: T): Future<Unit>
  fun get(key: String): Future<T>
  fun getOrNull(key: String): Future<T?>
  fun getOrDefault(key: String, default: T): Future<T>
  fun getKeys(): Future<List<String>>
  fun getAll(): Future<Map<String, T>>
  fun delete(key: String): Future<Unit>
  fun exists(key: String): Future<Boolean>
  fun serve(key: String, routingContext: RoutingContext, cacheTimeout: Duration)
}