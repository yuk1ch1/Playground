import UIKit

class Solution {
    func findDisappearedNumbers(_ nums: [Int]) -> [Int] {
        return Array(Set(1...nums.count).subtracting(nums))
    }
    
    // 全探索はやっぱり基本的にしないようにする
    func badAnswer(_ nums: [Int]) -> [Int] {
        var result: [Int] = []
        
        // numsはArrayなのでRandomAccessCollectionにしているためcountの計算量はO(1)
        for i in 1...nums.count {
            // でも全探索を使っていてcontainsがO(n)なので予想数分計算量は増えてしまうので処理が遅い
            if !nums.contains(i) {
                result.append(i)
            }
        }
        
        return result
    }
}

let solution = Solution()
print(solution.findDisappearedNumbers([1,2,1,3,3,4,5,6,3,5,7]))


