/**
 * Utility functions for use of vertx
 */

package com.acn.dlt.corda.networkmap.utils

import com.acn.dlt.corda.networkmap.service.NetworkMapService
import io.netty.handler.codec.http.HttpHeaderValues
import io.netty.handler.codec.http.HttpResponseStatus
import io.vertx.core.AsyncResult
import io.vertx.core.Future
import io.vertx.core.Future.*
import io.vertx.core.Vertx
import io.vertx.core.buffer.Buffer
import io.vertx.core.file.FileSystem
import io.vertx.core.http.HttpHeaders
import io.vertx.core.http.HttpServerResponse
import io.vertx.core.json.Json
import io.vertx.core.json.JsonArray
import io.vertx.core.json.JsonObject
import io.vertx.ext.web.RoutingContext
import net.corda.core.concurrent.CordaFuture
import net.corda.core.utilities.ByteSequence
import net.corda.core.utilities.getOrThrow
import net.corda.core.utilities.loggerFor
import java.time.Duration
import java.util.concurrent.atomic.AtomicInteger

private val logger = loggerFor<NetworkMapService>()

fun RoutingContext.end(text: String) {
	val length = text.length
	response().apply {
		putHeader(HttpHeaders.CONTENT_LENGTH, length.toString())
		putHeader(HttpHeaders.CONTENT_TYPE, HttpHeaderValues.TEXT_PLAIN)
		end(text)
	}
}

fun RoutingContext.handleExceptions(fn: RoutingContext.() -> Unit) {
	try {
		this.fn()
	} catch (err: Throwable) {
		logger.error("web request failed", err)
		response()
			.setStatusCode(HttpResponseStatus.INTERNAL_SERVER_ERROR.code())
			.setStatusMessage(err.message)
			.end()
	}
}

fun RoutingContext.setNoCache(): RoutingContext {
	response().setNoCache()
	return this
}


fun RoutingContext.end(byteSequence: ByteSequence) {
	response().apply {
		putHeader(HttpHeaders.CONTENT_TYPE, HttpHeaderValues.APPLICATION_JSON)
		putHeader(HttpHeaders.CONTENT_LENGTH, byteSequence.size.toString())
		end(Buffer.buffer(byteSequence.bytes))
	}
}

fun <T : Any> RoutingContext.end(obj: T) {
	val result = Json.encode(obj)
	response().apply {
		putHeader(HttpHeaders.CONTENT_TYPE, HttpHeaderValues.APPLICATION_JSON)
		putHeader(HttpHeaders.CONTENT_LENGTH, result.length.toString())
		end(result)
	}
}

fun RoutingContext.end(json: JsonObject) {
	val result = json.encode()
	response().apply {
		putHeader(HttpHeaders.CONTENT_TYPE, HttpHeaderValues.APPLICATION_JSON)
		putHeader(HttpHeaders.CONTENT_LENGTH, result.length.toString())
		end(result)
	}
}

fun RoutingContext.end(json: JsonArray) {
	val result = json.encode()
	response().apply {
		putHeader(HttpHeaders.CONTENT_TYPE, HttpHeaderValues.APPLICATION_JSON)
		putHeader(HttpHeaders.CONTENT_LENGTH, result.length.toString())
		end(result)
	}
}

fun RoutingContext.end(err: Throwable) {
	response().apply {
		statusCode = 500
		statusMessage = err.message
		end()
	}
}

fun HttpServerResponse.setNoCache(): HttpServerResponse {
	return putHeader(HttpHeaders.CACHE_CONTROL, "no-cache, no-store, must-revalidate")
		.putHeader("pragma", "no-cache")
		.putHeader("expires", "0")
}

fun HttpServerResponse.setCacheControl(cacheTimeout: Duration): HttpServerResponse {
	return putHeader(HttpHeaders.CACHE_CONTROL, "max-age=${cacheTimeout.seconds}")
}

fun <T> Vertx.executeBlocking(fn: () -> T): Future<T> {
	val result = Future.future<T>()
	this.executeBlocking({ f: Future<T> ->
		try {
			f.complete(fn())
		} catch (err: Throwable) {
			f.fail(err)
		}
	}) {
		result.handle(it)
	}
	return result
}

fun <T> Future<T>.onSuccess(fn: (T) -> Unit): Future<T> {
	val result = Future.future<T>()
	setHandler {
		try {
			if (it.succeeded()) {
				fn(it.result())
			}
			result.handle(it)
		} catch (err: Throwable) {
			result.fail(err)
		}
	}
	return result
}

fun <T> Future<T>.catch(fn: (Throwable) -> Unit): Future<T> {
	val result = Future.future<T>()
	setHandler {
		try {
			if (it.failed()) {
				fn(it.cause())
			}
			result.handle(it)
		} catch (err: Throwable) {
			result.fail(err)
		}
	}
	return result
}

fun <T> Future<T>.finally(fn: (AsyncResult<T>) -> Unit): Future<T> {
	val result = Future.future<T>()
	setHandler {
		try {
			fn(it)
			result.handle(it)
		} catch (err: Throwable) {
			result.fail(err)
		}
	}
	return result
}

fun <T> List<Future<T>>.all(): Future<List<T>> {
	if (this.isEmpty()) return succeededFuture(emptyList())
	val results = mutableMapOf<Int, T>()
	val fResult = future<List<T>>()
	val countdown = AtomicInteger(this.size)
	this.forEachIndexed { index, future ->
		future.setHandler { ar ->
			when {
				ar.succeeded() && fResult.succeeded() -> {
					logger.error("received a successful result in List<Future<T>>.all after all futures where apparently completed!")
				}
				fResult.failed() -> {
					// we received a result after the future was deemed failed. carry on.
				}
				ar.succeeded() -> {
					results[index] = ar.result()
					if (countdown.decrementAndGet() == 0) {
						fResult.complete(results.entries.sortedBy { it.key }.map { it.value })
					}
				}
				else -> {
					// we've got a failed future - report it
					fResult.fail(ar.cause())
				}
			}
		}
	}
	return fResult
}

@JvmName("allTyped")
fun <T> all(vararg futures: Future<T>): Future<List<T>> {
	return futures.toList().all()
}

@Suppress("UNCHECKED_CAST")
fun all(vararg futures: Future<*>): Future<List<*>> {
	return (futures.toList() as List<Future<Any>>).all() as Future<List<*>>
}

fun FileSystem.mkdirs(path: String): Future<Void> {
	return withFuture { mkdirs(path, it) }
}

fun FileSystem.readFile(path: String): Future<Buffer> {
	return withFuture { readFile(path, it) }
}

fun FileSystem.writeFile(path: String, byteArray: ByteArray): Future<Void> {
	return withFuture { writeFile(path, Buffer.buffer(byteArray), it) }
}

fun FileSystem.readDir(path: String): Future<List<String>> {
	return withFuture { readDir(path, it) }
}

fun FileSystem.copy(from: String, to: String): Future<Void> {
	return withFuture { copy(from, to, it) }
}

fun FileSystem.readFiles(dirPath: String): Future<List<Pair<String, Buffer>>> {
	return readDir(dirPath)
		.compose { files ->
			files.map { file ->
				readFile(file).map { buffer -> file to buffer }
			}.all()
		}
}

fun FileSystem.deleteFile(filePath: String): Future<Unit> {
	return withFuture { future ->
		delete(filePath) {
			if (it.succeeded()) {
				future.complete(Unit)
			} else {
				future.fail(it.cause())
			}
		}
	}
}

inline fun <T> withFuture(fn: (Future<T>) -> Unit): Future<T> {
	val result = future<T>()
	fn(result)
	return result
}

fun <T> Future<T>.completeFrom(value: T?, err: Throwable?) {
	return when {
		err != null -> fail(err)
		else -> complete(value)
	}
}

fun <T> CordaFuture<T>.toVertxFuture(): Future<T> {
	val result = Future.future<T>()
	this.then { f ->
		try {
			result.complete(f.getOrThrow())
		} catch (err: Throwable) {
			result.fail(err)
		}
	}
	return result
}

fun <T : Any> Vertx.retry(maxRetries: Int, sleepMillis: Long, fn: () -> Future<T>): Future<T> =
	fn().recover { exception ->
		when (maxRetries) {
			0 -> failedFuture(exception)
			else -> {
				sleep(sleepMillis).compose {
					this.retry(maxRetries - 1, sleepMillis, fn)
				}
			}
		}
	}

fun Vertx.sleep(sleepMillis: Long) = future<Unit>().apply {
	setTimer(sleepMillis) {
		complete()
	}
}!!

