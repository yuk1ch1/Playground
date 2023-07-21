import UIKit

var greeting = "Hello, playground"



public class ListNode {
    public var value: Int
    public var next: ListNode?
    public init(_ value: Int) {
        self.value = value
        self.next = nil
    }
}

class Solution {
    func middleNode(_ head: ListNode?) -> ListNode? {
        var end = head
        var middle = head

        // endがnilになった時のmiddleを返せ倍からend != nilかと思ったけど
        // 例えばリストが[1,2,3]などの奇数個の時
        // end != nilのみだと返される値は[3]になってしまうのでそれへの対応
        while end != nil, end?.next != nil {
            end = end?.next?.next
            middle = middle?.next
        }

        return middle
    }
}

let node1 = ListNode(1)
let node2 = ListNode(2)
let node3 = ListNode(3)
let node4 = ListNode(4)
node1.next = node2
node2.next = node3
node3.next = node4

let result = Solution().middleNode(node4)

