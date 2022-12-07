import UIKit

var greeting = "Hello, playground"


class Solution {
    func climbStairs(_ n: Int) -> Int {
        if n == 1 { return 1}

        var n2 = 1
        var n3 = 1
        var new = 0

        for _ in 2...n {
            new = n2 + n3
            n2 = n3
            n3 = new
        }

        return new
    }
}
