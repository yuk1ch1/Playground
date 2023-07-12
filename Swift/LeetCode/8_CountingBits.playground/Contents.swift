import UIKit

class Solution {
//    func countBits(_ n: Int) -> [Int] {
//
//    }
    func test(_ n: Int) -> String.UTF16View {
        n.description.utf16
    }
}
let aaa = Solution().test(101)
print(aaa)

/*
 Input: n = 2
 Output: [0,1,1]
 Explanation:
 0 --> 0
 1 --> 1
 2 --> 10
 */


/*
 Input: n = 5
 Output: [0,1,1,2,1,2]
 Explanation:
 0 --> 0
 1 --> 1
 2 --> 10
 3 --> 11
 4 --> 100
 5 --> 101

 */
