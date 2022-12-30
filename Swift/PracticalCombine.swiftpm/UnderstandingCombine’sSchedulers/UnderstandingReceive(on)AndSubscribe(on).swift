//
//  File.swift
//  
//
//  Created by s_yamada on 2022/12/28.
//

import Foundation
import Combine

let intSubject = PassthroughSubject<Int, Never>()
let namedDispatchQueue = DispatchQueue(label: "com.donnywals.queue")

// Combine has a default scheduler to the work you do.
// The default scheduler will emit values downstream on the thread that they were generated
// result will be (1)main thread (2)&(3) subthread
func testDefaultScheduler() {
    intSubject
        .sink(receiveValue: { value in
        print(value)
        print(Thread.current)
    }).store(in: &cancellables)
    
    sendValues()
}

func testOperatorReceiveOn() {
    intSubject
        .receive(on: DispatchQueue.global()) // this will deliver all events downstream on the scheduler you provide, like RunLoop, DispatchQueue, OperationQueue.
        .sink(receiveValue: { value in
        print(value)
        print(Thread.current) // result is affected by receive(on:)
    }).store(in: &cancellables)
    
    sendValues()
}

func testOperatorSubscribeOn() {
    intSubject
        .subscribe(on: DispatchQueue.global()) // just specify the scheduler on which to perform subscribe, cancel, and request operations
    // In contrast with receive(on:), subscribe(on:) affects upstream
        .sink(receiveValue: { value in
        print(value)
        print(Thread.current) // result is not affected by subscribe, that is because subscribe(on:) affects upstream
    }).store(in: &cancellables)
    
    sendValues()
}


func sendValues() {
    intSubject.send(1)
    
    DispatchQueue.global().async {
        intSubject.send(2)
    }
    
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    queue.underlyingQueue = namedDispatchQueue

    queue.addOperation {
        intSubject.send(3)
    }
}

class SubscribeOnUseCase {
    func generateInt() -> Future<Int, Never> {
        return Future { promise in
            print(Thread.current)
            promise(.success(Int.random(in: 1...10)))
        }
    }
    
    func executeGenerateIntWithoutSubscribe() {
        generateInt()
            .map({ value in
                sleep(1)
                return value
            })
            .sink(receiveValue: { value in
                print(Thread.current)
                print(value)
            }).store(in: &cancellables)
        
        print("hello!")
        
        // result
        // 10
        // hello!
    }
    
    func executeGenerateIntWithSubscribe() {
        generateInt()
            .map({ value in
                sleep(1)
                return value
            })
            .subscribe(on: DispatchQueue.global())
            .sink(receiveValue: { value in
                print(Thread.current) // subthread because subscribe(on:) affects the entire chain of publishers and operators.
                print(value)
            }).store(in: &cancellables)
        
        print("hello!")
        
        // result
        // hello
        // 10
    }
    
    func executeMixType() {
        generateInt()
          .subscribe(on: DispatchQueue.global())
          .map({ value in
            sleep(1)
            return value
          })
//          .receive(on: DispatchQueue.main)
          .sink(receiveValue: { value in
              print(Thread.current) // subthread without .receive(on: DispatchQueue.main), mainthread with .receive(on: DispatchQueue.main)
              print(value)
          }).store(in: &cancellables)
        
        print("hello!")
    }
}
