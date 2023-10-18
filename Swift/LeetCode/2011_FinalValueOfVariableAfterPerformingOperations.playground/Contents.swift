import UIKit

var greeting = "Hello, playground"
class Solution {
    /// LeetCode上では一番速かった処理
    func finalValueAfterOperations(_ operations: [String]) -> Int {
           var x = 0

           for element in operations {
               if(element == "++X" || element == "X++"){
                   x+=1
               }else if(element == "--X" || element == "X--"){
                   x-=1
               }
           }
           return x
       }

    /// パターン1
//    func finalValueAfterOperations(_ operations: [String]) -> Int {
//        operations.reduce(0) { partialResult, next in
//            var partialResult = partialResult
//            if next == "X++" || next == "++X" {
//                partialResult += 1
//            } else {
//                partialResult -= 1
//            }
//            return partialResult
//        }
//    }

    /// パターン2
//    enum Params: String {
//        case plus   = "++X"
//        case plus2  = "X++"
//        case minus  = "--X"
//        case minus2 = "X--"
//    }

//    func finalValueAfterOperations(_ operations: [String]) -> Int {
//        var x = 0
//
//        for element in operations {
//            guard let param = Params(rawValue: element) else { return x}
//            switch param {
//            case .plus, .plus2:
//                x += 1
//            case .minus, .minus2:
//                x -= 1
//            }
//        }
//        return x
//    }
}

print(Solution().finalValueAfterOperations(["++X","X++","X++"]))

let operations2: [String] = []
operations2.reduce(0) { partialResult, next in
    var partialResult = partialResult
    if next == "X++" || next == "X++" {
        partialResult += 1
    } else {
        partialResult -= 1
    }
    return partialResult
}
