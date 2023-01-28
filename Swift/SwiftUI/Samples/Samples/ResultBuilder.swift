//
//  ResultBuilder.swift
//  Samples
//
//  Created by s_yamada on 2023/01/09.
//

import SwiftUI

// MARK: - understand how resultBuilder works
@resultBuilder
struct ArrayBuilder<Element> {

    static func buildBlock(_ components: Element...) -> [Element] {
        components
    }
}

@ArrayBuilder<Int>
func executeArrayBuilder() -> [Int] {
    1
    2
    3
}

// understand how the code above works under the hood
func returnIntArray() -> [Int] {
    let v0 = 0
    let v1 = 0
    let v2 = 2
    return ArrayBuilder.buildBlock(v0,v1,v2)
}

func returnStringArray() -> [String] {
    let v0 = "0"
    let v1 = "1"
    let v2 = "2"
    return ArrayBuilder.buildBlock(v0,v1,v2)
}

// MARK: - ResultBuilder + if (no else)
@resultBuilder
struct ArrayBuilder2<Int> {

    static func buildExpression(_ expression: Int) -> [Int] {
        [expression]
    }

    static func buildBlock(_ components: [Int]...) -> [Int] {
        components.flatMap { $0 }
    }

    static func buildOptional(_ component: [Int]?) -> [Int] {
        component ?? []
    }
}

@ArrayBuilder2<Int>
func executeArrayBuilder2() -> [Int] {
    1

    if Bool.random() {
        2
        3
    }
}

// understand how the code above works under the hood
func executeWithoutArrayBuilder2() -> [Int] {
    let v0: [Int] = ArrayBuilder2.buildExpression(1)
    let v1: [Int]
    if Bool.random() {
        let v1_0: [Int] = ArrayBuilder2.buildExpression(2)
        let v1_1: [Int] = ArrayBuilder2.buildExpression(3)
        let v1_block: [Int] = ArrayBuilder2.buildBlock(v1_0, v1_1)
        v1 = ArrayBuilder2.buildOptional(v1_block)
    } else {
        v1 = ArrayBuilder2.buildOptional(nil)
    }
    return ArrayBuilder2.buildBlock(v0, v1)
}

// MARK: - ResultBuilder + if-else, switch
@resultBuilder
struct ArrayBuilder3<Int> {

    static func buildExpression(_ expression: Int) -> [Int] {
        [expression]
    }

    static func buildBlock(_ components: [Int]...) -> [Int] {
        components.flatMap { $0 }
    }

    static func buildEither(first component: [Int]) -> [Int] {
        component
    }

    static func buildEither(second component: [Int]) -> [Int] {
        component
    }
}

@ArrayBuilder3<Int>
func executeArrayBuilder3() -> [Int] {
    1

    if Bool.random() {
        2
    } else {
        3
    }
}

// understand how the code above works under the hood
func executeWithoutArrayBuilder3() -> [Int] {
    let v0: [Int] = ArrayBuilder3.buildExpression(1)
    let v1: [Int]
    if Bool.random() {
        let v1_0: [Int] = ArrayBuilder3.buildExpression(2)
        v1 = ArrayBuilder3.buildEither(first: v1_0)
    } else {
        let v1_1: [Int] = ArrayBuilder3.buildExpression(3)
        v1 = ArrayBuilder3.buildEither(second: v1_1)
    }
    return ArrayBuilder3.buildBlock(v0, v1)
}

// MARK: - ResultBuilder + loop
@resultBuilder
struct ArrayBuilder4<Int> {

    static func buildBlock(_ components: [Int]...) -> [Int] {
        components.flatMap { $0 }
    }

    static func buildExpression(_ expression: Int) -> [Int] {
        [expression]
    }

    static func buildArray(_ components: [[Int]]) -> [Int] {
        components.flatMap { $0 }
    }
}
@ArrayBuilder4<Int>
func executeArrayBuilder4() -> [Int] {
    for i in 1...3 {
        i
    }
}

// understand how the code above works under the hood
func executeWithoutArrayBuilder4() -> [Int] {
    var v0: [[Int]] = []
    for i in 1...3 {
        let i_block = ArrayBuilder4.buildExpression(i)
        v0.append(i_block)
    }
    let v0_array = ArrayBuilder4.buildArray(v0)
    return v0_array
}

// MARK: - resultBuilder for debugging
@resultBuilder
public struct DebugPrinter {
    public static func buildBlock<T: CustomDebugStringConvertible>(
        _ component: T,
        file: String = #file,
        function: String = #function,
        line: Int = #line) -> T {
            print(file, function, line, component.debugDescription)
            return component
        }
}

// MARK: - About CustomDebugStringConvertible
struct Point {
    let x: Int, y: Int
}

struct Point2: CustomDebugStringConvertible {
    let x: Int, y: Int
    
    var debugDescription: String {
        return "(\(x), \(y))"
    }
}

func testPoint() {
    let p = Point(x:21, y:30)
    debugPrint(p)
    print(String(reflecting: p))
    
    let p2 = Point2(x:21, y:30)
    let  s = String(reflecting: p2)
    
    print(s)
}
