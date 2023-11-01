import UIKit

// 文字列探索を使って解決
class Solution {
    func interpret(_ command: String) -> String{
        var command = command
        command.replace("(al)", with: "al")
        command.replace("()", with: "o")
        return command
    }
}

let result = Solution().interpret("qa")
print(result)


/// なぜかLeetCodeの方ではreplaceを持ってないことになったからAPIのインターフェースをもとに書いてみた
extension RangeReplaceableCollection where Self.Element : Equatable {

    /// Replaces all occurrences of a target sequence with a given collection
    /// - Parameters:
    ///   - other: The sequence to replace.
    ///   - replacement: The new elements to add to the collection.
    ///   - maxReplacements: A number specifying how many occurrences of `other`
    ///   to replace. Default is `Int.max`.
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
    public mutating func replace2<C, Replacement>(_ other: C, with replacement: Replacement, maxReplacements: Int = .max) where C : Collection, Replacement : Collection, Self.Element == C.Element, C.Element == Replacement.Element {

        guard !isEmpty, !other.isEmpty, maxReplacements > 0 else { return
        }

        var replacedCount = 0
        var currentIndex = startIndex


        while currentIndex < endIndex, replacedCount < maxReplacements {
            if self[currentIndex...].starts(with: other) {

                let replaceStartIndex = currentIndex
                let replaceEndIndex = index(currentIndex, offsetBy: other.count, limitedBy: endIndex) ?? endIndex

                /*
                 var nums = [10, 20, 30, 40, 50]
                 nums.replaceSubrange(1...3, with: repeatElement(1, count: 5))
                 print(nums)
                 */
                replaceSubrange(replaceStartIndex..<replaceEndIndex, with: replacement)

                /*
                 let s = "Swift"
                 let i = s.index(s.startIndex, offsetBy: 4)
                 print(s[i])
                 // Prints "t"
                 */
                currentIndex = index(currentIndex, offsetBy: replacement.count)

                replacedCount += 1
            } else {
                currentIndex = index(after: currentIndex)
            }
        }
    }
}

/*
 (解説)

 - guard !isEmpty, !other.isEmpty, maxReplacements > 0 else { return }とwhile currentIndex < endIndex, replacedCount < maxReplacements {については議論の余地なし

 - if self[currentIndex...].starts(with: other) {について

 var original = "Hello, world! Have a good world!"
 let replacement = "world"
 を例にしてみてみてる

 currentIndex = startIndexとしているので、originalのcurrentIndexは0(正確には0とか1ではなくてIndex(_rawBits: 15)みたいな感じだけど)
 indexを使った文字の抽出は
 textArray[index]みたいにするのでself[currentIndex...]やself[..<endIndex]はその文字列をすべて取り出す処理になっている
 つまりself[currentIndex...].starts(with: other)というのはここの例で言えばselfがworldで開始されているかをチェックしている

 1回目: "Hello, world! Have a good world!"なのでNo
 currentIndex = index(after: currentIndex)が実行される

 2回目: "ello, world! Have a good world!なのでNo
 currentIndex = index(after: currentIndex)が実行される
 .
 .
 .
 8回目: "world! Have a good world!"なのでworldから始まっているためYes。

要は self[currentIndex...] によって、現在のcurrentIndexからコレクションの終端までのサブシーケンスを作成
そして、starts(with:)メソッドは、あるシーケンスが別のシーケンスで開始されているかどうかをチェックする

したがって、self[currentIndex...].starts(with: other) は、現在のcurrentIndexから開始されるサブシーケンスが、otherというシーケンスで開始されているかどうかを判定しています。
 */
