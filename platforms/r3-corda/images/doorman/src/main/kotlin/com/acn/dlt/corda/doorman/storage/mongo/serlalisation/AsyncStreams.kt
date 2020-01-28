package com.acn.dlt.corda.doorman.storage.mongo.serlalisation

import com.mongodb.reactivestreams.client.Success
import com.mongodb.reactivestreams.client.gridfs.AsyncOutputStream
import io.netty.buffer.Unpooled
import io.vertx.core.buffer.Buffer
import io.vertx.ext.web.RoutingContext
import net.corda.core.utilities.loggerFor
import org.reactivestreams.Publisher
import org.reactivestreams.Subscription
import java.io.OutputStream
import java.nio.ByteBuffer

fun RoutingContext.asAsyncOutputStream(): AsyncOutputStream {
  return RoutingContextAsyncOutputStream(this)
}

class RoutingContextAsyncOutputStream(private val routingContext: RoutingContext) : AsyncOutputStream {
  companion object {
    private val log = loggerFor<RoutingContextAsyncOutputStream>()
  }

  override fun write(src: ByteBuffer?): Publisher<Int> {
    return when (src) {
      // case: when no source passed in - we should comply to reactive streams spec
      null -> Publisher { subscriber ->
        subscriber.onSubscribe(object : Subscription {
          override fun cancel() {
            routingContext.response().setStatusCode(500).setStatusMessage("stream cancelled").end()
          }

          override fun request(n: Long) {
            subscriber.onNext(0)
            subscriber.onComplete()
          }
        })
      }
      // case: when we've passed in a source ...
      else -> Publisher { subscriber ->
        subscriber.onSubscribe(object : Subscription {
          override fun cancel() {
            routingContext.response().setStatusCode(500).setStatusMessage("stream cancelled").end()
          }

          override fun request(n: Long) {
            val size = src.remaining()
            try {
              // please note, whilst this is as efficient it can be, improvements are needed in the mongo driver
              // to ensure we don't accrue unecessary JVM on-heap buffers
              // https://jira.mongodb.org/browse/JAVA-3118
              val wrapped = Buffer.buffer(Unpooled.wrappedBuffer(src).slice(0, size))
              routingContext.response().write(wrapped)
              subscriber.onNext(size)
              subscriber.onComplete()
            } catch (err: Throwable) {
              log.error("failed to wrap and send buffer for response", err)
              subscriber.onError(err)
            }
          }
        })
      }
    }
  }

  override fun close(): Publisher<Success> {
    // NB: the mongo reactive streams driver doesn't respect the reactive streams protocol
    // and never calls the close method on the output stream!
    return Publisher { subscriber ->
      subscriber.onSubscribe(object : Subscription {
        override fun cancel() {
          routingContext.response().setStatusCode(500).setStatusMessage("stream cancelled").end()
        }

        override fun request(n: Long) {
          routingContext.response().end()
          subscriber.onNext(Success.SUCCESS)
          subscriber.onComplete()
        }
      })
    }
  }
}

fun OutputStream.toAsyncOutputStream(): AsyncOutputStream {
  @Suppress("DEPRECATION")
  return com.mongodb.reactivestreams.client.internal.GridFSAsyncStreamHelper.toAsyncOutputStream(
    com.mongodb.async.client.gridfs.helpers.AsyncStreamHelper.toAsyncOutputStream(this))
}
