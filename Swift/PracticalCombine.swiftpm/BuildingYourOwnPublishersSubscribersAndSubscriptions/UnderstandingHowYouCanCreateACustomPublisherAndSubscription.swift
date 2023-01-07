//
//  File.swift
//  
//
//  Created by s_yamada on 2022/12/31.
//


import Foundation
import Combine

fileprivate extension Publishers {
    struct IntPublisher: Publisher {
        typealias Output = Int
        typealias Failure = Never
        
        let numberOfValues: Int
        
        func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
            let subscription = Subscriptions.IntSubscription(numberOfValues: numberOfValues,subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
    }
}

fileprivate extension Subscriptions {
    class IntSubscription<S: Subscriber>: Subscription where S.Input == Int, S.Failure == Never {
        let numberOfValues: Int
        var currentValue = 0
        
        var subscriber: S?
        
        var openDemand = Subscribers.Demand.none
        
        init(numberOfValues: Int, subscriber: S) {
            self.numberOfValues = numberOfValues
            self.subscriber = subscriber
        }
        
        func request(_ demand: Subscribers.Demand) {
            openDemand += demand
            
            while openDemand > 0 && currentValue < numberOfValues {
                if let newDemand = subscriber?.receive(currentValue) {
                    openDemand += newDemand
                }
                
                currentValue += 1
                openDemand -= 1
            }
            
            if currentValue == numberOfValues {
                subscriber?.receive(completion: .finished)
                cancel()
            }
        }
        
        func cancel() {
            subscriber = nil
            // we don't have anything to clean up
        }
    }
}

func executecCustomIntPublisher() {
    let customIntPublisher = Publishers.IntPublisher(numberOfValues: 10)
    customPublisher
        .customSink(receiveCompletion: { completion in
            print(completion)
        }, receiveValue: { int in
            print(int)
        })
        .store(in: &cancellables)
}
