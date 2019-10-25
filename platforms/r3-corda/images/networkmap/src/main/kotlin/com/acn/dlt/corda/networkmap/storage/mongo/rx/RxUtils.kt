package com.acn.dlt.corda.networkmap.storage.mongo.rx

import org.reactivestreams.Publisher
import rx.Observable
import rx.RxReactiveStreams

fun <T> Publisher<T>.toObservable(): Observable<T> {
  return RxReactiveStreams.toObservable(this)
}