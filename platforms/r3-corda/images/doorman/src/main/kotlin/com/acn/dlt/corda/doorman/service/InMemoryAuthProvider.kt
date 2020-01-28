package com.acn.dlt.corda.doorman.service

import io.vertx.core.AsyncResult
import io.vertx.core.Future.succeededFuture
import io.vertx.core.Handler
import io.vertx.core.json.JsonObject
import io.vertx.ext.auth.AbstractUser
import io.vertx.ext.auth.AuthProvider
import net.corda.core.crypto.SecureHash

class InMemoryUser(val name: String, val username: String, password: String) : AbstractUser() {
  companion object {
    fun createUser(name: String, username: String, password: String) = InMemoryUser(name, username, password)
  }

  internal val passwordHash = SecureHash.sha256(password)

  override fun doIsPermitted(permission: String?, resultHandler: Handler<AsyncResult<Boolean>>?) {
    resultHandler?.handle(succeededFuture(true))
  }

  override fun setAuthProvider(authProvider: AuthProvider?) {
  }

  override fun principal(): JsonObject {
    return JsonObject()
      .put("name", name)
      .put("username", username)
  }
}

