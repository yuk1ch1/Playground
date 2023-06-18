//
//  VariadicView.swift
//  Samples
//
//  Created by s_yamada on 2023/05/18.
//

/*
 SwiftUI の Variadic View という半公開的な API を使い、独自のコンポネントの API をより SwiftUI らしいものにする
 */

import SwiftUI

struct Ocean: Identifiable {
    let id = UUID()
    let name: String
}

private var oceans = [
    Ocean(name: "Pacific"),
    Ocean(name: "Atlantic"),
    Ocean(name: "Indian"),
    Ocean(name: "Southern"),
    Ocean(name: "Arctic")
]

func test111() {
    let list: List<Never, ForEach<[Ocean], UUID, Text>> = List(oceans) {
        Text($0.name)
    }
    let list2: List<Never, ForEach<[Ocean], UUID, Text>> = List.init(oceans) { Text($0.name)
    }

}

let stack: VStack<TupleView<(Text, Text, Text)>> = VStack {
    Text("First")
    Text("Second")
    Text("Third")
}


let list: List<Never, TupleView<(Text, Text, Text)>> = List {
    Text("A List Item")
    Text("A Second List Item")
    Text("A Third List Item")
}


public struct MyStruct {
    public var number: Int

    @inlinable
    public func doubleNumber() -> Int {
        return number * 2
    }

    public func doubleNumber2() -> Int {
        return number * 2
    }
}

func mysttest() {
    let myst = MyStruct(number: 2)
    myst.doubleNumber()
    myst.doubleNumber2()
}


public struct MyStruct2 {
    @usableFromInline
    internal var number: Int

    public init(number: Int) {
        self.number = number
    }

    @inlinable
    public func doubleNumber() -> Int {
        return number * 2
    }
}


func myst2test() {
    let myst = MyStruct2(number: 2)
    myst.doubleNumber()
//    myst.doubleNumber2()
}
