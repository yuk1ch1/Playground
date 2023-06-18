import SwiftUI

// 参照: https://docs.swift.org/swift-book/documentation/the-swift-programming-language/expressions/#Key-Path-Expression

/*
 subscript
*/

class Score {
    let multiplier: Int
    private var scores = [10,20,30,40,50,60,70]

    init(multiplier: Int) {
        self.multiplier = multiplier
    }

    subscript(index: Int) -> Int {
        get {
            return scores[index]
        }

        set(newValue) {
            scores[index] = newValue
        }
    }
}

let score = Score(multiplier: 2)
print(score[0])
score[0] = 100
print(score[0])

/*
 KeyPath
*/

struct Person {
    var name: String
    var currentAge: Int
    var nextAge: Int {
        return currentAge + 1
    }
}
let inputName = "Hoge"
let inputAge = 0

let person = Person(name: inputName, currentAge: inputAge)
let pathToName: WritableKeyPath<Person, String> = \.name
let pathToCurrentAge: WritableKeyPath<Person, Int> = \Person.currentAge
let pathToNextAge: KeyPath<Person, Int> = \.nextAge

// subscript(keyPath:) is available on all types.
let name = person[keyPath: pathToName]
let currentAge = person[keyPath: pathToCurrentAge]
let nextAge = person[keyPath: pathToNextAge]

print(name == inputName && currentAge == inputAge && nextAge == inputAge + 1) // true

func age(_ key: KeyPath<Person, Int>) ->Int {
    return person[keyPath: key]
}

print(age(\.currentAge)) // 0
print(age(\.nextAge)) // 1
// \.selfを使ってインスタンスを取得
print(person[keyPath: \.self]) // Person(name: "Hoge", currentAge: 0)



var compoundValue = (a: 1, b: 2)

// \.selfを使えば一気にまとめて変更することもできる
compoundValue[keyPath: \.self] = (a: 10, b: 20)
print(compoundValue)// Equivalent to compoundValue = (a: 10, b: 20)




/*
 KeyPathのメリット
 - 型安全性
 - コードの簡潔性
 - 柔軟性
 */


class Person2 {
    var name: String
    var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

let bob = Person2(name: "Bob", age: 30)
let alice = Person2(name: "Alice", age: 25)
func printProperty(of person: Person2, keyPath: KeyPath<Person2, String>) {
    print(person[keyPath: keyPath])
}

printProperty(of: bob, keyPath: \.name)

//func updateProperty<T>(of object: Person2, keyPath: WritableKeyPath<Person2, T>, to newValue: T) {
//    object[keyPath: keyPath] = newValue
//}
//
//updateProperty(of: bob, keyPath: \.age, to: 32)  // bobの年齢は32になります
//updateProperty(of: alice, keyPath: \.name, to: "Alicia")  // aliceの名前は"Alicia"になります
