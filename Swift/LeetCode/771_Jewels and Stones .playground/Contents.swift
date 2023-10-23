import UIKit

class Solution {
    func numJewelsInStones(_ jewels: String, _ stones: String) -> Int {
        return stones.filter { stone in
            jewels.contains(stone)
        }.count
    }
}

let result = Solution().numJewelsInStones("z", "ZzZ")
print(result)
