import Combine
import Foundation
/*
 PublisherとSubscriberって何？
 
 Combine declares publishers to expose values that can change over time, and subscribers to receive those values from the publishers.
 The Publisher protocol declares a type that can deliver a sequence of values over time. Publishers have operators to act on the values received from upstream publishers and republish them.
 At the end of a chain of publishers, a Subscriber acts on elements as it receives them. Publishers only emit values when explicitly requested to do so by subscribers. This puts your subscriber code in control of how fast it receives events from the publishers it’s connected to.
 
 ref: https://developer.apple.com/documentation/combine
 
 
 目的のデータを時系列順に送る output stream みたいなもの
 Subscriberがそのstreamを受け取る側
 
 参考: https://www.toyship.org/2020/07/24/195001
 */

// Chained Publisher
func patter1() {
    let numbers = [1,2,3,4,5]
    numbers.publisher
        .sink(receiveCompletion: { print("completion: \($0)") },
              receiveValue: { print("receivedValue: \($0)") })
}
// patter1()

// (結果)
// value: 1
// value: 2
// value: 3
// value: 4
// value: 5
// completion: finished


// publisher と subscriberを明確に分けてみる
func patter2() {
    let numbers = [1,2,3,4,5]
    let publisher = numbers.publisher
    let subscriber = Subscribers.Sink<Int, Never>(
        receiveCompletion: { comp in print("completion: \(comp)")},
        receiveValue: {val in print("receivedValue: \(val)")}
    )
    publisher.subscribe(subscriber)
}

// patter2()


/*
 subjectはpublisherとしては余計な機能があるけど、eraseToAnyPublisherを使って
 以下のように値を送り出すsubjectと外部公開用のpublisherを分けるやり方はよくあるみたい
 (参考: https://zenn.dev/usamik26/articles/combine-start-with-subject)
 
    private let settingSubject: CurrentValueSubject<Int, Never>
    public let settingPublisher: AnyPublisher<Int, Never>
 
    .
    .
    .
    
    setttingSubject = CurrentVaueSubject<Int, Never>(0)
    settingPublisher = setttingSubject.eraseToAnyPublisher()
 
    .
    .
    .
 
    settingPublisher.sink(receiveValue: { val in print("receivedValue: \(val)") })
 
    .
    .
    .
 
    settingSubject.send(1)
    
    (結果)
    receivedValue: 1
 */

// PassthroughSubject
func pattern3() {
    let numbers = [1,2,3,4,5]
    // PassthroughSubjectはCurrentValueSubjectとちがって初期値を持つことができない
    let subject = PassthroughSubject<Int, Never>()
    let publisher = subject.eraseToAnyPublisher()
    publisher.sink(
        receiveCompletion: { comp in print("completion: \(comp)")},
        receiveValue: {val in print("receivedValue: \(val)")}
    )
    numbers.forEach{
        subject.send($0)
    }
    subject.send(completion: .finished)
}

// pattern3()
// (結果)
// value: 1
// value: 2
// value: 3
// value: 4
// value: 5
// completion: finished


// CurrentValueSubject
func pattern4() {
    let numbers = [1,2,3,4,5]
    // CurrentValueSubjectはPassthroughSubjectとちがって初期値を持つことがで切る
    let subject = CurrentValueSubject<Int, Never>(0)
    let publisher = subject.eraseToAnyPublisher()
    publisher.sink(
        receiveCompletion: { comp in print("completion: \(comp)")},
        receiveValue: {val in print("receivedValue: \(val)")}
    )
    numbers.forEach{
        subject.send($0)
    }
    subject.send(completion: .finished)
}

//pattern4()
// (結果)
// value: 0
// value: 1
// value: 2
// value: 3
// value: 4
// value: 5
// completion: finished


/*
 Publisher はいつとまるのか
 - Publisher側からCompletionを送るパターン
 - Subscriber側からキャンセルするパターン
 これらをpattern4を参考に書いてみる
 
 
 参考: https://www.toyship.org/2020/07/24/195001
 */

// Publisher側からCompletionを送るパターン
func pattern5() {
    let numbers = [1,2,3,4,5]
    let subject = CurrentValueSubject<Int, Never>(0)
    let publisher = subject.eraseToAnyPublisher()
    publisher.sink(
        receiveCompletion: { comp in print("completion: \(comp)")},
        receiveValue: {val in print("receivedValue: \(val)")}
    )
    numbers.forEach{
        subject.send($0)
    }
    subject.send(completion: .finished)
    subject.send(6) // completionが送られてるので6は出力されない
}
//pattern5()

// (結果)
// receivedValue: 0
// receivedValue: 1
// receivedValue: 2
// receivedValue: 3
// receivedValue: 4
// receivedValue: 5
// completion: finished


// Subscriber側からキャンセルするパターン
func pattern6() {
    let numbers = [1,2,3,4,5]
    var cancellables = [AnyCancellable]()
    let subject = CurrentValueSubject<Int, Never>(0)
    let publisher = subject.eraseToAnyPublisher()
    publisher.sink(
        receiveCompletion: { comp in print("completion: \(comp)")},
        receiveValue: {val in print("receivedValue: \(val)")}
    )
    .store(in: &cancellables)
    
    numbers.forEach{
        subject.send($0)
    }
    cancellables.first?.cancel()
    subject.send(6) // cancelされたので6は出力されない
}
//pattern6()
// (結果)
// receivedValue: 0
// receivedValue: 1
// receivedValue: 2
// receivedValue: 3
// receivedValue: 4
// receivedValue: 5


/*
 @Publisherを使うことでAnyPublisherに直すコードを省くことができる
 
    private let settingSubject: CurrentValueSubject<Int, Never>
    public let settingPublisher: AnyPublisher<Int, Never>
 
 ようにしていたけど、わざわざSubjectからAnyPublisherにする必要がなくなる

 
 > Publishing a property with the `@Published` attribute creates a publisher of this type. You access the publisher with the `$` operator, as shown here:
 */

class Dummy {
    @Published
    var value = 0
}

func pattern7() {
    let dummy = Dummy()
    dummy.$value
        .dropFirst()
        .sink(
            receiveCompletion: { comp in print("completion: \(comp)") },
            receiveValue: { val in print("receivedValue: \(val)") }
        )
    [1,2,3,4,5].forEach { dummy.value = $0 }
}
//pattern7()

// publishing occurs in the property’s willSet blockを理解
class Weather {
    @Published var temperature: Double
    init(temperature: Double) {
        self.temperature = temperature
    }
}

func test8() {
    let weather = Weather(temperature: 20)
    let cancellable = weather.$temperature
        .sink() {
            print(weather.temperature) // result is 1st: 20.0, 2nd: 20.0. The readson is written on the official document.  "When the property changes, publishing occurs in the property’s willSet block, meaning subscribers receive the new value before it’s actually set on the property. "
            print ("Temperature now: \($0)")
            let aaa: Published<Double>.Publisher.Output = $0
        }
    weather.temperature = 25
}

test8()

