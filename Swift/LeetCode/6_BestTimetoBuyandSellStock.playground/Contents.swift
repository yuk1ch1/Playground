import UIKit

class Solution {
    func maxProfit(_ prices: [Int]) -> Int {
        var profit = 0
        var buy = prices[0]
        
        for price in prices {
            if price < buy {
                buy = price
            } else if price - buy > profit {
                profit = price - buy
            }
        }
        return profit
    }
}

let solution = Solution()

solution.maxProfit([8,3,0,1])
// [7,1,5,3,6,4]
