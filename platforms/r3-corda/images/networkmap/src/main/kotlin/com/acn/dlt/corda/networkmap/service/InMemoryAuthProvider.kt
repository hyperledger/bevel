package com.acn.dlt.corda.networkmap.service

import io.vertx.core.AsyncResult
import io.vertx.core.Future.failedFuture
import io.vertx.core.Future.succeededFuture
import io.vertx.core.Handler
import io.vertx.core.json.Json
import io.vertx.core.json.JsonObject
import io.vertx.ext.auth.AbstractUser
import io.vertx.ext.auth.AuthProvider
import io.vertx.ext.auth.User
import net.corda.core.crypto.SecureHash
import net.corda.core.utilities.loggerFor

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

class InMemoryAuthProvider(private val inMemoryUser: InMemoryUser) : AuthProvider {
  companion object {
    val log = loggerFor<InMemoryAuthProvider>()
    private val authFailed = failedFuture<User>("authentication failed")
  }

  override fun authenticate(authInfo: JsonObject?, resultHandler: Handler<AsyncResult<User>>?) {
    assert(authInfo != null) { "authInfo must not be null" }
    assert(resultHandler != null) { "resultHandler must not be null" }
    val loginRequest = Json.decodeValue(authInfo!!.encode(), AuthService.LoginRequest::class.java)
    if (inMemoryUser.username == loginRequest.user && inMemoryUser.passwordHash == SecureHash.sha256(loginRequest.password)) {
      resultHandler!!.handle(succeededFuture(inMemoryUser))
    } else {
      resultHandler!!.handle(authFailed)
    }
  }
}
