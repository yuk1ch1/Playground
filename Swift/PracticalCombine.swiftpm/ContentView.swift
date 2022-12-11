import SwiftUI
import Combine

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }.onAppear {
            singleNumber([1,1,2,3,2,4,5,6,2,6,7])
        }
    }
}


func test() {
    
    let aaa: Array<String> = ["one", "2", "three", "4", "5"]
    let bbb: Publishers.Sequence<[String], Never> = aaa.publisher
    let ccc: Publishers.Sequence<[Int?], Never> = bbb.map { text -> Int? in
        Int(text)
    }
    let ddd: Publishers.Sequence<[Int?], Never> = ccc.replaceNil(with: 0)
    
    
    let result = ["one", "2", "three", "4", "5"].publisher
        .map({ Int($0) })
        .replaceNil(with: 0)
        .compactMap({ $0 })
        .sink(receiveValue: { int in
            print(int) // int is now a non-optional Int
        })
}

func test2() {
    let numbers = [5,6,7,8,9]
    let mapped = numbers.map { Array(repeating: $0, count: $0)}
    print(mapped)
    
    let flatMapped = numbers.flatMap{ Array(repeating: $0, count: $0)}
    print(flatMapped)
}


func test3() {
    var baseURL = URL(string: "https://www.donnywals.com")!
    
    //    let fdfd =  ["/", "/the-blog", "/speaking", "/newsletter"].publisher
    //        .map({ path in
    //          let url = baseURL.appendingPathComponent(path)
    //          return URLSession.shared.dataTaskPublisher(for: url)
    //        })
    
    
    ["/", "/the-blog", "/speaking", "/newsletter"]
        .publisher
        .map({ path in
            let url = baseURL.appendingPathComponent(path)
            return URLSession.shared.dataTaskPublisher(for: url)
        })
        .sink(receiveCompletion: { completion in
            print("Completed with: \(completion)")
        }, receiveValue: { result in
            print(result)
        })
    
}
var cancellables = Set<AnyCancellable>()

func test4() {
    var baseURL = URL(string: "https://www.donnywals.com")!
    
    ["/", "/the-blog", "/speaking", "/newsletter"]
        .publisher
        .print("パブリッシャが呼ばれました")
        .flatMap(maxPublishers: .max(1), { path -> URLSession.DataTaskPublisher in
            let url = baseURL.appendingPathComponent(path)
            return URLSession.shared.dataTaskPublisher(for: url)
        })
    //        .flatMap({ path -> URLSession.DataTaskPublisher in
    //            let url = baseURL.appendingPathComponent(path)
    //            return URLSession.shared.dataTaskPublisher(for: url)
    //        })
        .sink(receiveCompletion: { completion in
            print("Completed with: \(completion)")
        }, receiveValue: { result in
            print("結果:\(result)")
        }).store(in: &cancellables)
    
}
func test4_dummy() {
    var baseURL = URL(string: "https://www.donnywals.com")!
    
    ["/", "/the-blog", "/speaking", "/newsletter"].publisher
        .setFailureType(to: URLError.self)
        .flatMap({ path -> URLSession.DataTaskPublisher in
            let url = baseURL.appendingPathComponent(path)
            return URLSession.shared.dataTaskPublisher(for: url)
        })
        .sink(receiveCompletion: { completion in
            print("Completed with: \(completion)")
        }, receiveValue: { result in
            print(result)
        }).store(in: &cancellables)
}


func test5_PassthroughSubject_Pattern() {
    var cancellables = Set<AnyCancellable>()
    
    let notificationSubject = PassthroughSubject<Notification, Never>()
    let notificationName = UIResponder.keyboardWillShowNotification
    let notificationCenter = NotificationCenter.default
    
    notificationCenter.addObserver(forName: notificationName, object: nil, queue: nil) { notification in
        notificationSubject.send(notification)
    }
    
    notificationSubject
        .sink(receiveValue: { notification in
            print(notification)
        }).store(in: &cancellables)
    
    notificationCenter.post(Notification(name: notificationName))
}

class Car {
    var onBatteryChargeChanged: ((Double) -> Void)?
    var kwhInBattery = 50.0 {
        didSet {
            onBatteryChargeChanged?(kwhInBattery)
        }
    }
    
    let kwhPerKilometer = 0.14
    
    func drive(kilometers: Double) {
        let kwhNeeded = kilometers * kwhPerKilometer
        
        assert(kwhNeeded <= kwhInBattery, "Can't make trip, not enough charge in battery")
        
        kwhInBattery -= kwhNeeded
    }
}

class Car2 {
    var kwhInBattery = CurrentValueSubject<Double, Never>(50.0)
    let kwhPerKilometer = 0.14
    
    func drive(kilometers: Double) {
        let kwhNeeded = kilometers * kwhPerKilometer
        
        assert(kwhNeeded <= kwhInBattery.value, "Can't make trip, not enough charge in battery")
        
        kwhInBattery.value -= kwhNeeded
    }
}

class Car3 {
    @Published var kwhInBattery = 50.0
    let kwhPerKilometer = 0.14
    
    func drive(kilometers: Double) {
        let kwhNeeded = kilometers * kwhPerKilometer
        
        assert(kwhNeeded <= kwhInBattery, "Can't make trip, not enough charge in battery")
        
        kwhInBattery -= kwhNeeded
    }
}


func test6_DidSet_Pattern() {
    let car = Car()
    let someLabel = UILabel()
    someLabel.text = "The car now has \(car.kwhInBattery)kwh in its battery"
    
    car.onBatteryChargeChanged = { newCharge in
        someLabel.text = "The car now has \(newCharge)kwh in its battery"
    }
}

func test7_CurrentValueSubject_Pattern() {
    let car2 = Car2()
    let someLabel = UILabel()
    // don't forget to store the AnyCancellable if you're using this in a real app
    car2.kwhInBattery
        .sink(receiveValue: { newCharge in
            someLabel.text = "The car now has \(newCharge)kwh in its battery"
        })
}

func test8_PropertyWrapperPublished_Pattern() {
    
    let car = Car3()
    let someLabel = UILabel()
    // don't forget to store the AnyCancellable if you're using this in a real app
    car.$kwhInBattery
        .sink(receiveValue: { newCharge in
            someLabel.text = "The car now has \(newCharge)kwh in its battery"
        })
}

class Counter {
  @Published var publishedValue = 1
  var subjectValue = CurrentValueSubject<Int, Never>(1)
}

func testDiff_Published_CurrentValueSubject() {
    let c = Counter()
    c.$publishedValue.sink(receiveValue: { int in
        print("published", int == c.publishedValue)
    })
    .store(in: &cancellables)
    
    c.subjectValue.sink(receiveValue: { int in
        print("subject", int == c.subjectValue.value)
    })
    .store(in: &cancellables)
    c.publishedValue = 2
    c.subjectValue.value = 2
}


func testDiff_Publshed_CurrentValueSubject2() {
    let counter = Counter()
    
}



func singleNumber(_ nums: [Int]) -> Int {
    var result = nums[0]
    for n in nums[1...] {
        result ^= n
        print(result)
    }
    return result
}

// [1,1,2,3,2,4,5,6,2,6,7]

class Car4 {
  @Published var kwhInBattery = 50.0
  let kwhPerKilometer = 0.14
}

struct CarViewModel {
    var car: Car4
    
    lazy var batterySubject: AnyPublisher<String?, Never> = {
        return car.$kwhInBattery.map({ newCharge in
            return "The car now has \(newCharge)kwh in its battery"
        })
        .eraseToAnyPublisher()
    }()
    
    
    mutating func drive(kilometers: Double) {
        let kwhNeeded = kilometers * car.kwhPerKilometer
        
        assert(kwhNeeded <= car.kwhInBattery, "Can't make trip, not enough charge in battery")
        
        car.kwhInBattery -= kwhNeeded
    }
}

class CarStatusViewController {
    let label = UILabel()
    let button = UIButton()
    var viewModel: CarViewModel
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: CarViewModel) {
        self.viewModel = viewModel
    }
    
    // setup code goes here
    
    func setupLabel() {
      viewModel.batterySubject
        .assign(to: \.text, on: label)
        .store(in: &cancellables)
    }
    
    func buttonTapped() {
        viewModel.drive(kilometers: 10)
    }
}

//struct CardModel: Hashable, Decodable {
//  let title: String
//  let subTitle: String
//  let imageName: String
//}

//class DataProvider {
//    let dataSubject = CurrentValueSubject<[CardModel], Never>([])
//
//    var currentPage = 0
//    var cancellables = Set<AnyCancellable>()
//
//    func fetch() {
//        let cards = (0..<20).map { i in
//            CardModel(title: "Title \(i)", subTitle: "Subtitle \(i)", imageName: "image_\(i)")
//        }
//
//        dataSubject.value = cards
//    }
//
//    func fetch() -> AnyPublisher<[CardModel], Never> {
//        let cards = (0..<20).map { i in
//            CardModel(title: "Title \(i)", subTitle: "Subtitle \(i)", imageName: "image_\(i)")
//        }
//
//        return Just(cards).eraseToAnyPublisher()
//    }
//
//    func fetchNextPage() {
//      let url = URL(string: "https://myserver.com/page/\(currentPage)")!
//      currentPage += 1
//
//      URLSession.shared.dataTaskPublisher(for: url)
//        .sink(receiveCompletion: { _ in
//          // handle completion
//        }, receiveValue: { [weak self] value in
//          guard let self = self else { return }
//
//          let jsonDecoder = JSONDecoder()
//          if let models = try? jsonDecoder.decode([CardModel].self, from: value.data) {
//            self.dataSubject.value += models
//          }
//        }).store(in: &cancellables)
//    }
//}

