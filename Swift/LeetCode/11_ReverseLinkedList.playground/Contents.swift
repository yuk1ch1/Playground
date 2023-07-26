import UIKit

var greeting = "Hello, playground"

public class ListNode {
    public var val: Int
    public var next: ListNode?

    public init() {
        self.val = 0
        self.next = nil
    }

    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }

    public init(_ val: Int, _ next: ListNode?) {
        self.val = val
        self.next = next
    }
}

class Solution {
    func reverseList(_ head: ListNode?) -> ListNode? {
        var previous: ListNode? = nil
        var current = head

//        [1,2,3,4,5]
        while current != nil {
            let next: ListNode? = current?.next
            current?.next = previous
            previous = current
            current = next
        }
        return previous
    }
}
