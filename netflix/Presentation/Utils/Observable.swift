//
//  Observable.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation

private protocol ObservableInput {
    associatedtype Value
    init(_ value: Value)
    func observe(on observer: AnyObject,
                 block: @escaping (Value) -> Void)
    func remove(observer: AnyObject)
    func notifyObservers()
}

private protocol ObservableOutput: ObservableInput {
    var observers: [Observable<Value>.Observer<Value>] { get }
    var value: Value { get }
}

private typealias Observing = ObservableInput & ObservableOutput

final class Observable<Value>: Observing {
    fileprivate struct Observer<Value> {
        private(set) weak var observer: AnyObject?
        let block: (Value) -> Void
    }
    
    fileprivate var observers = [Observer<Value>]()
    
    var value: Value { didSet { notifyObservers() } }
    
    init(_ value: Value) { self.value = value }
    
    fileprivate func notifyObservers() {
        for observer in observers {
            DispatchQueue.main.async {
                observer.block(self.value)
            }
        }
    }
    
    func observe(on observer: AnyObject,
                 block: @escaping (Value) -> Void) {
        observers.append(Observer(observer: observer, block: block))
        block(self.value)
    }
    
    func remove(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }
}
