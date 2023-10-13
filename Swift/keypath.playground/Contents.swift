import UIKit


/*
 https://zenn.dev/link/comments/f3c9c8425edfe3 の記事を書くために使った

struct Child {
    var name: String
    var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

struct Parent {
    var name: String
    var child: Child

    init(name: String, child: Child) {
        self.name = name
        self.child = child
    }
}
let child = Child(name: "fuga", age: 20)
let father = Parent(name: "hoge", child: child)

//let childAgeKeyPath = \Parent.child.age
//let ageKeyPath = \Child.age
//
//print(father[keyPath: childAgeKeyPath])
//
//
//func getValue<T, Value>(for object: T, keyPath: KeyPath<T,Value>) -> Value {
//    return object[keyPath: keyPath]
//}
//
//func setValue<T, Value>(for object: inout T, keyPath: WritableKeyPath<T, Value>, newValue: Value) {
//    object[keyPath: keyPath] = newValue
//}
//
//print(getValue(for: child, keyPath: \.age))
//print(getValue(for: father, keyPath: \.child.name))

struct Accessor<T> {
    private(set) var object: T

    init(_ object: T) {
        self.object = object
    }

    subscript<Value>(keyPath: WritableKeyPath<T, Value>) -> Value {
        get {
            return object[keyPath: keyPath]
        }
        set {
            object[keyPath: keyPath] = newValue
        }
    }
}


var accessor = Accessor(father)
print(accessor[\.child.age])

accessor[\.child.age] = 23
print(accessor[\.child.age])
*/

/*
 https://www.andyibanez.com/posts/understanding-keypaths-swift/ を理解するために書いたコード
 */

class Person {
    let familyName: String
    let lastName: String
    let age: Int

    init(familyName: String, lastName: String, age: Int) {
        self.familyName = familyName
        self.lastName = lastName
        self.age = age
    }

    func getAge() -> Int {
        return self[keyPath: \.age]
    }
}

class Parent {
    let relation: String
    let child: Person

    init(relation: String, child: Person) {
        self.relation = relation
        self.child = child
    }
}

let child = Person(familyName: "hoge", lastName: "fuga", age: 20)
let father = Parent(relation: "father", child: child)
let chiildAgeKeyPath = \Parent.child.age
print(father[keyPath: chiildAgeKeyPath])


let person = \Person.age
print(person)
let person1 = Person(familyName: "hoge", lastName: "fuga", age: 20)
print(person1[keyPath: \.age])
print(person1.getAge())

class Doll {
    let maker: String
    let name: String
    let releaseYear: Int

    init(name: String, maker: String, releaseYear: Int) {
        self.name = name
        self.maker = maker
        self.releaseYear = releaseYear
    }
}

let classAlice = Doll(name: "Classical Alice", maker: "Groove", releaseYear: 2013)

let dollMaker = \Doll.maker
print(dollMaker)
let aliceMaker = classAlice[keyPath: dollMaker]
print(aliceMaker) // Pullip


///*
// 特定のクラスに依存しない値の取得・設定
// */
//// Classの例
class Vehicle {
    var numberOfWheels: Int
    var color: String

    init(numberOfWheels: Int, color: String) {
        self.numberOfWheels = numberOfWheels
        self.color = color
    }

    func description() -> String {
        return "A \(color) vehicle with \(numberOfWheels) wheels."
    }
}

let car = Vehicle(numberOfWheels: 4, color: "red")

//// Structの例
struct Point {
    var x: Double
    var y: Double

    func distance(to point: Point) -> Double {
        return ((x - point.x) * (x - point.x) + (y - point.y) * (y - point.y)).squareRoot()
    }
}

let pointA = Point(x: 0.0, y: 0.0)
let pointB = Point(x: 3.0, y: 4.0)


func getValue<T, V>(from object: T, using keyPath: KeyPath<T, V>) -> V {
    return object[keyPath: keyPath]
}

func setValiue<T, V>(for object: inout T, useing keyPath: WritableKeyPath<T, V>, to newValue: V) {
    object[keyPath: keyPath] = newValue
}
print(getValue(from: pointA, using: \.x))
print(getValue(from: pointB, using: \.y))
print(getValue(from: car, using: \.color))
print(getValue(from: car, using: \.numberOfWheels))

struct Accessor<T> {
    private(set) var object: T

    init(_ object: T) {
        self.object = object
    }

    subscript<V>(keyPath: WritableKeyPath<T, V>) -> V {
        get {
            return object[keyPath: keyPath]
        }
        set {
            object[keyPath: keyPath] = newValue
        }
    }
}

var accessor = Accessor(car)
print(accessor[\.color])
accessor[\.color] = "blue"
print(accessor[\.color])
