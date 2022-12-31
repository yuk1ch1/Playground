//
//  File.swift
//  
//
//  Created by s_yamada on 2022/12/30.
//

import Foundation
import Combine

private let publisher = [1, 2, 3].publisher
private let subject = PassthroughSubject<Int, Never>()

private func executeDummySubscribe() {
    subject
        .sink(receiveValue: { receivedInt in
            print("subject", receivedInt)
        }).store(in: &cancellables)
    
    publisher
        .subscribe(subject)
        .store(in: &cancellables)
    
    publisher
        .sink(receiveValue: { a in
            print(a)
        })
        .store(in: &cancellables)
}

extension Publisher {
    func customSink(receiveCompletion: @escaping (Subscribers.Completion<Self.Failure>) -> Void,
                    receiveValue: @escaping (Self.Output) -> Void) -> AnyCancellable {
        
        let sink = Subscribers.CustomSink(receiveCompletion: receiveCompletion, receiveValue: receiveValue)
        self.subscribe(sink)
        return AnyCancellable(sink)
    }
}

extension Subscribers {
    class CustomSink<Input, Failure: Error>: Subscriber {
        let receiveCompletion: (Subscribers.Completion<Failure>) -> Void
        let receiveValue: (Input) -> Void
        
        var subscription: Subscription?
        
        init(receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void,
             receiveValue: @escaping (Input) -> Void) {
            
            self.receiveCompletion = receiveCompletion
            self.receiveValue = receiveValue
        }
        
        func receive(subscription: Subscription) {
            self.subscription = subscription
            subscription.request(.unlimited)
        }
        
        func receive(_ input: Input) -> Subscribers.Demand {
            receiveValue(input)
            return .none
        }
        
        func receive(completion: Subscribers.Completion<Failure>) {
            receiveCompletion(completion)
        }
    }
}

extension Subscribers.CustomSink: Cancellable {
  func cancel() {
    subscription?.cancel()
    subscription = nil
  }
}

