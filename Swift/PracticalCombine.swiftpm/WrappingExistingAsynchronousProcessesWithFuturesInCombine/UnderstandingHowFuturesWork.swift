//
//  File.swift
//  
//
//  Created by s_yamada on 2022/12/23.
//

import Foundation
import Combine

func createFutureSample() -> Future<Int, Never> {
    return Future { promise in
        promise(.success(Int.random(in: 0..<10)))
    }
}


func executeCreateFutureSample() {
    createFutureSample()
        .sink(receiveValue: { value in
            print(value)
        }).store(in: &cancellables)
}

let myURL = URL(string: "https://practicalcombine.com")!

func fetchURL(_ url: URL) -> Future<(data: Data, response: URLResponse), URLError> {
    return Future { promise in
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error as? URLError {
                promise(.failure(error))
            }
            
            if let data = data, let response = response {     promise(.success((data: data, response: response)))
            }
            
            print("RECEIVED RESPONSE")
        }.resume()
    }
}

let futurePublisher = fetchURL(myURL)

func subscribeFutureProvider() {
    futurePublisher
        .sink(receiveCompletion: { completion in
            print(completion)
        }, receiveValue: { value in
            print(value.data)
        }).store(in: &cancellables)
    
    futurePublisher
        .sink(receiveCompletion: { completion in
            print(completion)
        }, receiveValue: { value in
            print(value.data)
        }).store(in: &cancellables)
}

// result
//
// xxx bytes
// finished
// xxx bytes
// finished
// RECEIVED RESPONSE
//
// Difference with Future and Other Publisher is following
//
// - Future wil be executed immediately whn it is created regardless of whether you subscribe to it
// - Future will only runc once. Once a Future is completed, it will replay its output to new subscribers withou running again
//


/*
 The example below explains about Other Publisher:
 - Other Publisher will not perform work until it has subscribers
 - If you subscribe to the same instance of this publisher more than once, the work will be repeated
 
 
 // private struct DummyModel {}
 // let otherPublisher: AnyPublisher<DummyModel, Error> = fetchURL(myURL)
 //
 // otherPublisher
 //  .sink(receiveCompletion: { completion in
 //    print(completion)
 //  }, receiveValue: { (model: DummyModel) in
 //    print(model)
 //  }).store(in: &cancellables)
 //
 // otherPublisher
 //  .sink(receiveCompletion: { completion in
 //    print(completion)
 //  }, receiveValue: { (model: DummyModel) in
 //    print(model)
 //  }).store(in: &cancellables)
 
 */

fileprivate func createPlainFuture() -> Future<Int, Never> {
    return Future { promise in
        promise(.success(Int.random(in: (1...100))))
    }
}

fileprivate func createDeferredFuture() -> Deferred<Future<Int, Never>> {
    return Deferred {
        return Future { promise in
            promise(.success(Int.random(in: (1..<Int.max))))
        }
    }
}

fileprivate func testFuture() {
    
    let plainFuture = createPlainFuture()
    
    func subscribePlainFuture() {
        plainFuture.sink(receiveValue: { value in
            print("plain1", value)
        })
        
        plainFuture.sink(receiveValue: { value in
            print("plain2", value)
        })
    }
    
    let deferred = createDeferredFuture()
    
    func subscribeDeferredFuture() {
        deferred.sink(receiveValue: { value in
            print("deferred1", value)
        })
        
        deferred.sink(receiveValue: { value in
            print("deferred2", value)
        })
    }
    
    subscribePlainFuture()
    
    subscribeDeferredFuture()
}

/*
 Deffered Future acts as like any Other Publisher, it is recommended to transform the return type to AnyPublisher to avoid confusion using eraseToAnyPublisher().
 That makes it clear to them looking at your code that it is same as any ohter publisher
 */
