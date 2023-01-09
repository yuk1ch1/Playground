//
//  File.swift
//  
//
//  Created by s_yamada on 2023/01/09.
//

import Foundation
import Combine

struct ApiResponse {
  let hasMorePages: Bool
  let items: [String]
}

class NetworkObject {
  func loadPage(_ page: Int) -> Just<ApiResponse> {
    if page < 5 {
      return Just(ApiResponse(hasMorePages: true,
                              items: ["Item", "Item"]))
    } else {
      return Just(ApiResponse(hasMorePages: false,
                              items: ["Item", "Item"]))
    }
  }
}

struct RecursiveFetcher {
    let network: NetworkObject
    
    func loadAllPages() -> AnyPublisher<[String], Never> {
        let pageIndexPublisher = CurrentValueSubject<Int, Never>(0)
        
        return pageIndexPublisher
            .flatMap({ pageIndex in
                return network.loadPage(pageIndex)
            })
            .handleEvents(receiveOutput: { response in
                if response.hasMorePages {
                    pageIndexPublisher.value += 1
                } else {
                    pageIndexPublisher.send(completion: .finished)
                }
            })
            .reduce([String](), { collectedStrings, response in
                return response.items + collectedStrings
            })
            .eraseToAnyPublisher()
    }
}


func exe() {
    let fetcher = RecursiveFetcher(network: NetworkObject())
    fetcher.loadAllPages()
        .sink(receiveValue: { strings in
            print(strings)
        })
        .store(in: &cancellables)
}


//class Car {
//  @Published var kwhInBattery = 50.0
//  let kwhPerKilometer = 0.14
//}
//
//struct CarViewModel {
//  var car: Car
//
//  lazy var batterySubject: AnyPublisher<String?, Never> = {
//    return car.$kwhInBattery.map({ newCharge in
//      return "The car now has \(newCharge)kwh in its battery"
//    }).eraseToAnyPublisher()
//  }()
//
//  mutating func drive(kilometers: Double) {
//    let kwhNeeded = kilometers * car.kwhPerKilometer
//
//    assert(kwhNeeded <= car.kwhInBattery, "Can't make trip, not enough charge in battery")
//
//    car.kwhInBattery -= kwhNeeded
//  }
//}

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
//          guard let expectedValue = expectedValues.first else {
//            XCTFail("The publisher emitted more values than expected.")
//            return
//          }
//
//          guard expectedValue == value else {
//            XCTFail("Expected received value \(value) to match first expected value \(expectedValue)")
//            return
//          }
//
//          // This creates a new array with all elements from the original except the first element.
//          expectedValues = Array(expectedValues.dropFirst())
//
//          if expectedValues.isEmpty {
//            receivedAllValues.fulfill()
//          }
//        }).store(in: &cancellables)
//
//        car.kwhInBattery = newValue
//
//        waitForExpectations(timeout: 1, handler: nil)
//    }
//}

//class CarViewModelTest: XCTestCase {
//    var car: Car!
//    var carViewModel: CarViewModel!
//    var cancellables: Set<AnyCancellable>!
//
//    override func setUp() {
//        car = Car()
//        carViewModel = CarViewModel(car: car)
//        cancellables = []
//    }
//
//    func testCarViewModelEmitsCorrectStrings() {
//        let newValue: Double = car.kwhInBattery - car.kwhPerKilometer * 10
//        var expectedValues = [car.kwhInBattery, newValue].map { doubleValue in
//            return "The car now has \(doubleValue)kwh in its battery"
//        }
//
//        let receivedAllValues = expectation(description: "all values received")
//
//        carViewModel.batterySubject
//            .assertOutput(matches: expectedValues, expectation: receivedAllValues)
//            .store(in: &cancellables)
//
//        carViewModel.drive(kilometers: 10)
//
//        waitForExpectations(timeout: 1, handler: nil)
//    }
//}

//
//protocol ImageNetworking {
//  func loadURL(_ url: URL) -> AnyPublisher<Data, Error>
//}
//
//class ImageNetworkProvider: ImageNetworking {
//  func loadURL(_ url: URL) -> AnyPublisher<Data, Error> {
//    return URLSession.shared.dataTaskPublisher(for: url)
//      .mapError({$0 as Error})
//      .map(\.data)
//      .eraseToAnyPublisher()
//  }
//}
//
//enum ImageLoaderError: Error {
//    case invalidData
//}
//
//class ImageLoader {
//    var images = [URL: UIImage]()
//    var cancellables = Set<AnyCancellable>()
//
//    let network: ImageNetworking
//
//    init(_ notificationCenter: NotificationCenter = NotificationCenter.default,
//         network: ImageNetworking = ImageNetworkProvider()) {
//
//        self.network = network
//
//        // Notification center related code
//    }
//
//    func loadImage(at url: URL) -> AnyPublisher<UIImage, Error> {
//        if let image = images[url] {
//            return Just(image).setFailureType(to: Error.self).eraseToAnyPublisher()
//        }
//        return network.loadURL(url)
//            .tryMap({ data in
//                guard let image = UIImage(data: data) else {
//                    throw ImageLoaderError.invalidData
//                }
//                /*
//                 tryMapの役割ではない
//
//                 具体的にはtryMapとしてはdataを変換して、成功すれば変換後のimageを変換に失敗すればerrorをthrowするだけのはず
//                 なのにキャッシュを更新するという副作用(side effect)が入ってしまっている
//                 */
////                self.images[url] = image
//
//                return image
//            })
//            .handleEvents (receiveOutput: { self.images[url] = $0 })
//            .eraseToAnyPublisher()
//    }
//}
//
//class ImageLoader失敗例_URLSessionと密結合なのでテストできない{
//    var images = [URL: UIImage]()
//    var cancellables = Set<AnyCancellable>()
//
//    init(_ notificationCenter: NotificationCenter = NotificationCenter.default) {
//        let notification = UIApplication.didReceiveMemoryWarningNotification
//        notificationCenter.publisher(for: notification)
//            .sink(receiveValue: { [weak self] _ in
//                self?.images = [URL: UIImage]()
//            }).store(in: &cancellables)
//    }
//
//    func loadImage(at url: URL) -> AnyPublisher<UIImage, Error> {
//        if let image = images[url] {
//            return Just(image).setFailureType(to: Error.self).eraseToAnyPublisher()
//        }
//
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .mapError({ $0 as Error })
//            .tryMap({ response in
//                guard let image = UIImage(data: response.data) else {
//                    throw ImageLoaderError.invalidData
//                }
//
//                return image
//            })
//            .eraseToAnyPublisher()
//    }
//}
//

//class ImageLoaderTests: XCTestCase {
//    var cancellables = Set<AnyCancellable>()
//
//    override func setUp() {
//        cancellables = Set<AnyCancellable>()
//    }
//
//    func testImageLoaderClearsImagesOnMemoryWarning() {
//        // setup
//        let notificationCenter = NotificationCenter()
//        let imageLoader = ImageLoader(notificationCenter)
//
//        // store a dummy image
//        let image = UIImage(systemName: "house")
//        let url = URL(string: "https://fake.url/house")!
//        imageLoader.images[url] = image
//        XCTAssertNotNil(imageLoader.images[url])
//
//        // send memory warning
//        let memoryWarning = UIApplication.didReceiveMemoryWarningNotification
//        notificationCenter.post(Notification(name: memoryWarning))
//        // verify that the images are now gone
//        XCTAssertNil(imageLoader.images[url])
//    }
//
//    func testImageLoaderLoadsImageFromNetwork() {
//      // setup
//      let mockNetwork = MockImageNetworkProvider()
//      let notificationCenter = NotificationCenter()
//      let imageLoader = ImageLoader(notificationCenter, network: mockNetwork)
//      let url = URL(string: "https://fake.url/house")!
//
//      let result = awaitCompletion(for: imageLoader.loadImage(at: url))
//      XCTAssertNoThrow(try result.get())
//      XCTAssertEqual(mockNetwork.wasLoadURLCalled, true)
//      XCTAssertNotNil(imageLoader.images[url])
//    }
//
//    func testImageLoaderLoadsImageFromNetwork2() {
//        let mockNetwork = MockImageNetworkProvider()
//        let notificationCenter = NotificationCenter()
//        let imageLoader = ImageLoader(notificationCenter, network: mockNetwork)
//        let url = URL(string: "https://fake.url/house")!
//
//        // expectations
//        let loadCompleted = expectation(description: "expected image load to complete")
//        let imageReceived = expectation(description: "expected to receive an image")
//
//        // load the image
//        imageLoader.loadImage(at: url)
//            .sink(receiveCompletion: { completion in
//                guard case .finished = completion else {
//                    XCTFail("Expected load to complete succesfully")
//                    return
//                }
//
//                // verify our assumptions
//                XCTAssertEqual(mockNetwork.wasLoadURLCalled, true)
//                XCTAssertNotNil(imageLoader.images[url])
//
//                loadCompleted.fulfill()
//            }, receiveValue: { image in
//                // acknowledge that we received an image
//                imageReceived.fulfill()
//            }).store(in: &cancellables)
//
//        // wait for expectations
//        waitForExpectations(timeout: 1.0, handler: nil)
//    }
//
//    func testImageLoaderUsesCachedImageIfAvailable() {
//        // setup
//        let mockNetwork = MockImageNetworkProvider()
//        let notificationCenter = NotificationCenter()
//        let imageLoader = ImageLoader(notificationCenter, network: mockNetwork)
//        let url = URL(string: "https://fake.url/house")!
//
//        // populate the cache
//        imageLoader.images[url] = UIImage(systemName: "house")
//
//        // expectations
//        let loadCompleted = expectation(description: "expected image load to complete")
//        let imageReceived = expectation(description: "expected to receive an image")
//
//        // load the image
//        imageLoader.loadImage(at: url)
//            .sink(receiveCompletion: { completion in
//                guard case .finished = completion else {
//                    XCTFail("Expected load to complete succesfully")
//                    return
//                }
//
//                // verify our assumptions
//                XCTAssertEqual(mockNetwork.wasLoadURLCalled, false)
//                XCTAssertNotNil(imageLoader.images[url])
//
//                loadCompleted.fulfill()
//            }, receiveValue: { image in
//                // acknowledge that we received an image
//                imageReceived.fulfill()
//            }).store(in: &cancellables)
//
//        // wait for expectations
//        waitForExpectations(timeout: 1.0, handler: nil)
//    }
//
//    func awaitCompletion<P: Publisher>(for publisher: P) -> Result<[P.Output], P.Failure> {
//        let finishedExpectation = expectation(description: "completion expectation")
//        var output = [P.Output]()
//        var result: Result<[P.Output], P.Failure>!
//
//        _ = publisher.sink(receiveCompletion: { completion in
//            if case .failure(let error) = completion {
//                result = .failure(error)
//            } else {
//                result = .success(output)
//            }
//
//            finishedExpectation.fulfill()
//        }, receiveValue: { value in
//            output.append(value)
//        })
//
//        waitForExpectations(timeout: 10.0, handler: nil)
//
//        return result
//    }
//}
//
//class MockImageNetworkProvider: ImageNetworking {
//    var wasLoadURLCalled = false
//
//    func loadURL(_ url: URL) -> AnyPublisher<Data, Error> {
//        wasLoadURLCalled = true
//
//        let data = UIImage(systemName: "house")!.pngData()!
//        return Just(data)
//            .setFailureType(to: Error.self)
//            .eraseToAnyPublisher()
//    }
//}
//
//extension Publisher where Output: Equatable {
//    func assertOutput(matches: [Output], expectation: XCTestExpectation) -> AnyCancellable {
//        var expectedValues = matches
//        print("インスタンスの確認")
////        print(matches)
////        print(expectedValues)
//
//        return self.sink(receiveCompletion: { _ in
//            // we don't handle completion
//        }, receiveValue: { value in
//            guard  let expectedValue = expectedValues.first else {
//                XCTFail("The publisher emitted more values than expected.")
//                return
//            }
//
//            guard expectedValue == value else {
//                XCTFail("Expected received value \(value) to match first expected value \(expectedValue)")
//                return
//            }
//
//            expectedValues = Array(expectedValues.dropFirst())
//
//            if expectedValues.isEmpty {
//                expectation.fulfill()
//            }
//        })
//    }
//}
