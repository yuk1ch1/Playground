import UIKit

public class Node {
    public var val: Int
    public var next: Node?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

class Solution {
    func hasCycle(_ head: Node?) -> Bool {
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
let node1 = Node(1)
let node2 = Node(2)
let node3 = Node(3)
let node4 = Node(4)

node1.next = node2
node2.next = node3
node3.next = node4
node4.next = node2  // 循環を作成


let solution = Solution()
let result = solution.hasCycle(node1)
print(result)
