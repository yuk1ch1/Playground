import UIKit
// DynamicMemberLookupという型が新しく作られた

// https://www.hackingwithswift.com/articles/55/how-to-use-dynamic-member-lookup-in-swift
//  @dynamicMemberLookup, which instructs Swift to call a subscript method when accessing properties.
@dynamicMemberLookup
struct Person {
    subscript(dynamicMember member: String) -> String {
        let properties = ["name": "Taylor Swift", "city": "Nashville"]
        return properties[member, default: "valueが存在しないです"]
    }

    subscript(dynamicMember member: String) -> Int {
        let properties = ["age": 26, "height": 178]
        return properties[member, default: 0]
    }

    subscript(dynamicMember member: String) -> (_ input: String) -> Void {
        return {
            print("Hello! I live at the address \($0).")
        }
    }
}

let taylor = Person()
print(taylor.name as String) // "Taylor Swift"
print(taylor.city as String) // Nashville
print(taylor.favoriteIceCream as String) // "valueが存在しないです"
let age: Int = taylor.age
print(age)
taylor.printAddress("555 Taylor Swift Avenue") // 定義を辿れなかったけど@dynamicMemberLookupを消すとコンパイルエラーになったから@dynamicMemberLookupに定義されてるものなのかもしれない
// When that’s run, taylor.printAddress returns a closure that prints out a string, and the ("555 Taylor Swift Avenue") part immediately calls it with that input.
/*
 @dynamicMemberLookupのおかげでpersonに定義してなくても各プロパティアクセス可能
 コンパイル後実行→ランタイム時に各プロパティを探しに行く
 ただしこの時 “Taylor Swift” と “Nashville” はプリントされるけどfavoriteIceCreamはプリントされない
 なぜならpropertiesディクショナリはfavoriteIceCreamを持ってないから

 オーバーロードを使ってsubscript(dynamicMemberを２つ定義することは可能だけど
 戻り値としてどっちが返されることを期待しているのか明示する必要がある
 */


//@dynamicMemberLookup
//enum JSON {
//    case intValue(Int)
//    case stringValue(String)
//    case arrayValue(Array<JSON>)
//    case dictionaryValue(Dictionary<String, JSON>)
//
//    var stringValue: String? {
//        if case .stringValue(let str) = self {
//            return str
//        }
//        return nil
//    }
//
//    subscript(index: Int) -> JSON? {
//        if case .arrayValue(let arr) = self {
//            return index < arr.count ? arr[index] : nil
//        }
//        return nil
//    }
//
//    subscript(key: String) -> JSON? {
//        if case .dictionaryValue(let dict) = self {
//            return dict[key]
//        }
//        return nil
//    }
//
//    subscript(dynamicMember member: String) -> JSON? {
//        if case .dictionaryValue(let dict) = self {
//            return dict[member]
//        }
//        return nil
//    }
//}

@dynamicMemberLookup
struct JSON {
    private var data: [String: Any]

    init(data: [String: Any]) {
        self.data = data
    }

    subscript(dynamicMember member: String) -> Any? {
        return data[member]
    }
}

let json = JSON(data: ["dummy1": 1])
print(json.dummy1!)
