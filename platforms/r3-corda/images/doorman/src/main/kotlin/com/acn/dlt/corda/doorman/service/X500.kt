package com.acn.dlt.corda.doorman.service

import net.corda.core.identity.CordaX500Name
import org.bouncycastle.asn1.ASN1Encodable
import org.bouncycastle.asn1.ASN1ObjectIdentifier
import org.bouncycastle.asn1.x500.AttributeTypeAndValue
import org.bouncycastle.asn1.x500.X500Name
import org.bouncycastle.asn1.x500.style.BCStyle

fun X500Name.toCordaX500Name(strictEV: Boolean): CordaX500Name {
  val attributesMap: Map<ASN1ObjectIdentifier, ASN1Encodable> = this.rdNs
    .flatMap { it.typesAndValues.asList() }
    .groupBy(AttributeTypeAndValue::getType, AttributeTypeAndValue::getValue)
    .mapValues {
      require(it.value.size == 1) { "Duplicate attribute ${it.key}" }
      it.value[0]
    }

  val cn = attributesMap[BCStyle.CN]?.toString()
  val ou = attributesMap[BCStyle.OU]?.toString()
  val st = attributesMap[BCStyle.ST]?.toString()
  val o = attributesMap[BCStyle.O]?.toString()
    ?: if (!strictEV) "$cn-web" else throw IllegalArgumentException("X500 name must have an Organisation: ${this}")
  val l = attributesMap[BCStyle.L]?.toString()
    ?: if (!strictEV) "Antarctica" else throw IllegalArgumentException("X500 name must have a Location: ${this}")
  val c = attributesMap[BCStyle.C]?.toString()
    ?: if (!strictEV) "AQ" else throw IllegalArgumentException("X500 name must have a Country: ${this}")

  return CordaX500Name(cn, ou, o, l, st, c)
}