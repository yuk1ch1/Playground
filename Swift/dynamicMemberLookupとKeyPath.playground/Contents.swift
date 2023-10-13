import UIKit


@dynamicMemberLookup
struct Test {
    var color = UIColor.red

    subscript<T>(dynamicMember keyPath: KeyPath<UIColor, T>) -> T {
        color[keyPath: \.cgColor]
        return color[keyPath: keyPath]
    }
}

let test = Test()
print(test.color.cgColor)

/*
 形的には@dynamicMemberLookupとKeyPathを組み合わせることで
 @dynamicMemberLookupは存在しないプロパティにアクセスしたときにエラーでわかるようになったし
 KeyPathはtest.color.cgColorを見てわかる通り＼.でのアクセスじゃなくて
 .cgColorのように自然なアクセス方法に変わった
*/
