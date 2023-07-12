import UIKit

var greeting = "Hello, playground"

func singleNumber(_ nums: [Int]) -> Int {
    var result = nums[0]
    for n in nums[1...] {
        result ^= n
    }
    return result
}

