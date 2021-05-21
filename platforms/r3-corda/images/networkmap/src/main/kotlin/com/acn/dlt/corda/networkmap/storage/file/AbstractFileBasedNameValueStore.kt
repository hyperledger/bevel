package com.acn.dlt.corda.networkmap.storage.file

import com.acn.dlt.corda.networkmap.serialisation.deserializeOnContext
import com.acn.dlt.corda.networkmap.serialisation.serializeOnContext
import com.acn.dlt.corda.networkmap.storage.Storage
import com.acn.dlt.corda.networkmap.utils.all
import com.acn.dlt.corda.networkmap.utils.end
import com.acn.dlt.corda.networkmap.utils.handleExceptions
import io.netty.handler.codec.http.HttpHeaderValues
import io.vertx.core.Future
import io.vertx.core.Future.future
import io.vertx.core.Future.succeededFuture
import io.vertx.core.Vertx
import io.vertx.core.buffer.Buffer
import io.vertx.core.http.HttpHeaders
import io.vertx.ext.web.RoutingContext
import java.io.File
import java.time.Duration

abstract class AbstractFileBasedNameValueStore<T : Any>(
  private val dir: File,
  protected val vertx: Vertx
) : Storage<T> {
  companion object {
    inline fun <reified T : Any> deserialize(file: File, vertx: Vertx): Future<T> {
      val result = Future.future<Buffer>()
      vertx.fileSystem().readFile(file.absolutePath, result)
      return result.map {
        it.bytes.deserializeOnContext<T>()
      }
    }

    inline fun <reified T : Any> serialize(value: T, file: File, vertx: Vertx): Future<Unit> {
      val result = Future.future<Void>()
      vertx.fileSystem().writeFile(file.absolutePath, Buffer.buffer(value.serializeOnContext().bytes), result)
      return result.map { Unit }
    }
  }

  fun makeDirs(): Future<Unit> {
    val result = future<Void>()
    vertx.fileSystem().mkdirs(dir.absolutePath, result)
    return result.map { Unit }
  }

  override fun clear(): Future<Unit> {
    return getKeys()
      .compose { keys ->
        keys.map { key ->
          delete(key)
        }.all().map { Unit }
      }
  }

  override fun delete(key: String): Future<Unit> {
    val file = resolveKey(key)
    val result = future<Void>()
    vertx.fileSystem().deleteRecursive(file.absolutePath, true, result)
    return result.map { Unit }
  }

  override fun put(key: String, value: T): Future<Unit> {
    return write(key, value)
  }

  override fun get(key: String): Future<T> {
    return read(key)
  }

  override fun getOrNull(key: String): Future<T?> {
    return read(key).recover { succeededFuture() }
  }

  override fun getKeys(): Future<List<String>> {
    val fExists = future<Boolean>()
    vertx.fileSystem().exists(dir.absolutePath, fExists)
    return fExists.compose { exists ->
      if (exists) {
        val result = future<List<String>>()
        vertx.fileSystem().readDir(dir.absolutePath, result)
        result
      } else {
        succeededFuture<List<String>>(listOf())
      }
    }
      .map { paths ->
        paths.map { path -> File(path).name }
      }
  }
  
  override fun size(): Future<Int> {
    val fExists = future<Boolean>()
    vertx.fileSystem().exists(dir.absolutePath, fExists)
    return fExists.compose { exists ->
      if (exists) {
        val result = future<List<String>>()
        vertx.fileSystem().readDir(dir.absolutePath, result)
        result
      } else {
        succeededFuture<List<String>>(listOf())
      }
    }
    .compose{
      succeededFuture(it.size)
    }
  }
  
  override fun getAll(keys: List<String>) : Future<Map<String, T>> {
    return keys.map { key ->
      read(key).map { key to it }
    }.all()
      .map { it.toMap() }
  }

  override fun getAll(): Future<Map<String, T>> {
    return getKeys()
      .compose { keys ->
        getAll(keys)
      }
  }
  
  override fun getPage(page: Int, pageSize: Int): Future<Map<String, T>> {
    return getKeys()
      .compose { keys ->
        val keysByPage = keys.sorted().drop(pageSize * (page - 1)).take(pageSize)
        getAll(keysByPage)
      }
  }
  
  override fun serve(key: String, routingContext: RoutingContext, cacheTimeout: Duration) {
    routingContext.handleExceptions {
      routingContext.response().apply {
        putHeader(HttpHeaders.CACHE_CONTROL, "max-age=${cacheTimeout.seconds}")
        putHeader(HttpHeaders.CONTENT_TYPE, HttpHeaderValues.APPLICATION_OCTET_STREAM)
          .sendFile(resolveKey(key).absolutePath) {
            if (it.failed()) {
              routingContext.end(it.cause())
            }
          }
      }
    }
  }

  override fun exists(key: String): Future<Boolean> {
    val file = resolveKey(key)
    val result = future<Boolean>()
    vertx.fileSystem().exists(file.absolutePath, result)
    return result
  }

  protected open fun write(key: String, value: T): Future<Unit> {
    return serialize(value, resolveKey(key))
  }

  protected open fun read(key: String): Future<T> {
    val file = resolveKey(key)
    val result = future<T>()
    vertx.fileSystem().exists(file.absolutePath) {
      if (it.failed()) {
        result.fail(it.cause())
      } else {
        if (it.result()) {
          deserialize(file).setHandler(result)
        } else {
          result.fail("could not find key $key")
        }
      }
    }
    return result
  }

  fun resolveKey(key: String): File {
    return File(dir, key)
  }


  protected abstract fun deserialize(location: File): Future<T>
  protected abstract fun serialize(value: T, location: File): Future<Unit>
}