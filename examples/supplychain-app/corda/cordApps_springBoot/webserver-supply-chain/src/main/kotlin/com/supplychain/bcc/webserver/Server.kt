package com.supplychain.bcc.webserver

import org.springframework.boot.Banner
import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication

/**
 * Our Spring Boot application.
 */
@SpringBootApplication
private open class Starter

/**
 * Starts our Spring Boot application.
 */
fun main(args: Array<String>) {
    val app = SpringApplication(Starter::class.java)
    app.setBannerMode(Banner.Mode.OFF)
    app.run(*args)
}
