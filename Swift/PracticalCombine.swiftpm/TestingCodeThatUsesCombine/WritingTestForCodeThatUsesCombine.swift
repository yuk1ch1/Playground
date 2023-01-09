//
//  File.swift
//
//
//  Created by s_yamada on 2023/01/07.
//

import Foundation
import Combine
//import XCTest
//
//class Car {
//  @Published var kwhInBattery = 50.0
//  let kwhPerKilometer = 0.14
//}
//
//class CarTest: XCTestCase {
//    var car: Car!
//    var cancellables: Set<AnyCancellable>!
//
//    override func setUp() {
//        car = Car()
//        cancellables = []
//    }
//
//    func testKwhBatteryIsPublisher() {
//        let newValue: Double = 10.0
//        var expectedValues = [car.kwhInBattery, newValue]
//
//        let receivedAllValues = expectation(description: "all values received")
//
//        car.$kwhInBattery.sink(receiveValue: { value in
//            // we'll write the assertion logic here
//
//        }).store(in: &cancellables)
//
//        car.kwhInBattery = newValue
//
//        waitForExpectations(timeout: 1, handler: nil)
//    }
//}
