import UIKit

// 参照: https://qiita.com/happy_ryo/items/72b68859ed8ace9f5fb4
// subscriptとはDictionary とか Array で hoge["fuga"] みたいな感じで、要素にアクセスするアレ。


/// Read/Write
class SubscriptSample {
    var userNames: Array<String>

    init(){
        userNames = []
    }

    // subscript の受け取る引数は [] の中で渡すもの
    subscript(index: Int) -> String {
        get {
            assert(userNames.count > index, "index out of range")
            return userNames[index] + " さん 昨夜はお楽しみでしたね"
        }
        set(name) {
            assert(0 > index || userNames.count >= index, "index out of range")
            userNames.insert(name, at: index)
        }
    }

    subscript(index: Int) -> Int {
        assert(userNames.count > index, "index out of range")
        return userNames[index].count
    }

    subscript(nameIndex index: Int) -> Int {
        assert(userNames.count > index, "index out of range")
        return userNames[index].count
    }

    subscript(index: Int, sub: Int) -> Int {
        return 1
    }
}




func test() {
    let sample = SubscriptSample()
    sample[0] = "happy_ryo"
    sample[1] = "crazy_ryo"
    // オーバーロードを利用して複数のsubscriptを定義しているので戻り値を明記する必要がある
    let result1: String = sample[0]
    let result2: Int = sample[1]
    // 引数の型や数が同一でも外部引数名が異なれば、受け取り側での型指定は必要ない。
    let result3 = sample[nameIndex: 1]
    // Subscript では複数の引数を受け取ることも可能
    let result4 = sample[10, 10]
    print(result1)
    print(result2)
    print(result3)
    print(result4)
}

test()


/// ReadOnly
class SubscriptSample2 {
    let userName: String

    init(name: String){
        userName = name
    }

    // subscript の受け取る引数は [] の中で渡すもの
    subscript(action: String) -> String {
        return userName + " さん " + action
    }
}

func test2() {
    let sample = SubscriptSample2(name: "happy_ryo")
    print(sample["昨夜はお楽しみでしたね"])
    print(sample["今朝もお楽しみでしたね"])
}
