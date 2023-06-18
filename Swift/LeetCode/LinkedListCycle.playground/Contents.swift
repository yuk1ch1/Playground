import UIKit

var greeting = "Hello, playground"

/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     public var val: Int
 *     public var next: ListNode?
 *     public init(_ val: Int) {
 *         self.val = val
 *         self.next = nil
 *     }
 * }
 */
public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

class Solution2 {
    func hasCycle(_ head: ListNode?) -> Bool {
        var p1 = head
        var p2 = head

    while p2 != nil && p2?.next != nil {
        p1 = p1?.next
        p2 = p2?.next?.next

        if p1 === p2 {
            return true
        }
    }

    return false
    }
}

class Solution {
    func hasCycle(_ head: ListNode?) -> Bool {
        if head == nil {
            return false
        }
        var set = Set<ObjectIdentifier>()
        var root = head

        while let cur = root {
            let id = ObjectIdentifier(cur)

            if set.contains(id) {
                return true
            } else {
                set.insert(id)
                root = cur.next
            }
        }

        return false
    }
}


// 循環リンクリストの作成
let node1 = ListNode(1)
let node2 = ListNode(2)
let node3 = ListNode(3)
let node4 = ListNode(4)

node1.next = node2
node2.next = node3
node3.next = node4
node4.next = node2  // 循環を作成


let solution = Solution()
let result = solution.hasCycle(node1)
print(result)
