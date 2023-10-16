import UIKit
/*
 https://leetcode.com/problems/defanging-an-ip-address/description/
 */

class Solution {
    func defangIPaddr(_ address: String) -> String {
        return address.replacingOccurrences(of: ".", with: "[.]")
    }
}

let solution = Solution()
solution.defangIPaddr("255.100.50.0")




