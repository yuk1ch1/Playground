import UIKit

class Solution {
    func missingNumber(_ nums: [Int]) -> Int {
        let uniqueNums = Set(nums)
        return (Set(0...nums.endIndex)).subtracting(uniqueNums).first!
    }
    
    func bestAnswer(_ nums: [Int]) -> Int {
        var result = nums.count
        for (i, num) in nums.enumerated() {
            result += i - num
        }
        return result
    }
}
