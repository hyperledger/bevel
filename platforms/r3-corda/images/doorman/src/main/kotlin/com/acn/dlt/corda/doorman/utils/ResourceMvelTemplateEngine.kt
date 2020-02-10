package com.acn.dlt.corda.doorman.utils

import io.netty.handler.codec.http.HttpResponseStatus
import io.vertx.core.http.impl.MimeMapping
import io.vertx.ext.web.RoutingContext
import org.mvel2.integration.impl.ImmutableDefaultFactory
import org.mvel2.templates.TemplateCompiler
import org.mvel2.templates.TemplateRuntime
import org.mvel2.util.StringAppender
import java.io.FileNotFoundException
import javax.ws.rs.core.HttpHeaders

/**
 * vertx-web comes with a number of template engines
 * Unfortunately, these always process files from the filesystem,
 * rather than being capable to process resource files, like StaticHandler.
 * This class allows the processing of resource files
 */
class ResourceMvelTemplateEngine(
  val cachingEnabled: Boolean,
  private val properties: Map<String, String>,
  private val rootPath: String,
  private val fileSuffixWhitelist: List<String> = listOf("html", "xml")
) {
  val cache = mutableMapOf<String, String>()

  private fun resolvePath(path: String): String {
    return if (cachingEnabled) {
      cache.computeIfAbsent(path, this::resolvePathUncached)
    } else {
      resolvePathUncached(path)
    }
  }

  private fun resolvePathUncached(path: String): String {
    val text = ClassLoader.getSystemClassLoader().getResource(rootPath + path)?.readText()
      ?: throw FileNotFoundException(path)
    val template = TemplateCompiler.compileTemplate(text)
    return TemplateRuntime(template.template, null, template.root, ".").execute(StringAppender(), properties, ImmutableDefaultFactory()).toString()
  }

  fun handler(context: RoutingContext, rootPath: String) {
    try {
      val path = context.request().path().let {
        if (it.startsWith(rootPath)) {
          it.drop(rootPath.length)
        } else {
          it
        }.dropLastWhile { it == '/' }
      }.let {
        if (it.isEmpty()) {
          "index.html"
        } else {
          it
        }
      }
      val process = fileSuffixWhitelist.any { path.endsWith(".$it") }
      if (process) {
        val result = resolvePath(path)
        context.response()
          .putHeader(HttpHeaders.CONTENT_LENGTH, result.length.toString())
          .apply {
            val contentType = MimeMapping.getMimeTypeForFilename(path)
            if (contentType != null) {
              putHeader(HttpHeaders.CONTENT_TYPE, contentType)
            }
            putHeader("X-Content-Type-Options", "nosniff")
          }
          .end(result)
      } else {
        context.next()
      }
    } catch (err: FileNotFoundException) {
      context.response().setStatusCode(HttpResponseStatus.NOT_FOUND.code()).setStatusMessage("File not found").end()
    } catch (err: Throwable) {
      context.end(err)
    }
  }
}