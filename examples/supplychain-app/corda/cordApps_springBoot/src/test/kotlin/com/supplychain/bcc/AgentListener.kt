package com.supplychain.bcc

import co.paralleluniverse.fibers.instrument.JavaAgent
import com.ea.agentloader.AgentLoader
import org.testng.ITestContext
import org.testng.TestListenerAdapter


class AgentListener : TestListenerAdapter() {

    override fun onStart(testContext: ITestContext?) {
        super.onStart(testContext)

        //This injects the Quasar agent dynamically into the tests instead of requiring a JVM arg
        AgentLoader.loadAgentClass(JavaAgent::class.java.name, "")
    }
}