import UIKit

var greeting = "Hello, playground"
public class ListNode {
    public var value: Int
    public var next: ListNode?
    public init() {
        self.value = 0
        self.next = nil
    }
    public init(_ value: Int) {
        self.value = value
        self.next = nil
    }
    public init(_ value: Int, _ next: ListNode?) {
        self.value = value
        self.next = next
    }
}

class Solution {
    // [1,2,3,3,2,1]
    // [1,2,3,2,1]
    func isPalindrome(_ head: ListNode?) -> Bool {
        var fast: ListNode? = head
        var slow: ListNode? = head

        while fast != nil && fast?.next != nil {
            fast = fast?.next?.next
            slow = slow?.next
        }
        if fast != nil {
            slow = slow?.next
        }
        slow = reverse(slow)
        fast = head
        while slow != nil {
            if fast?.value != slow?.value {
                return false
            }
            fast = fast?.next
            slow = slow?.next
        }

        return true
    }

    private func reverse(_ head: ListNode?) -> ListNode? {
        var head = head
        var pre: ListNode? = nil

        while head != nil {
            let next = head?.next
            head?.next = pre
            pre = head
            head = next
        }

        return pre
    }
}

// メモ: https://zenn.dev/link/comments/a53aca42bf3028
