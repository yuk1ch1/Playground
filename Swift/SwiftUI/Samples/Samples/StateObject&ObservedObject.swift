//
//
// # Difference with StateObject and ObservedObject
// ## 前提
// @StateObject、ObservedObjectどちらも設定できるのはObservableObjectを継承しているクラスに対してのみ
//
// ## 構成
// - counter (親View)
//  - StateObjectCounter (子View)
//  - OvservedObjectCounter (子View)
//
// ## @StateObject と @ObservedObjectの違い
// StateObjectCounter: 親Viewのcounterが更新されても値を保持している。Viewに対してインスタンスが1つだけ生成されるため
// OvservedObjectCounter: Viewのライサイクルに依存しているので、親Viewが再描画される度(親Viewのプロパティが更新される度)に更新され保持するViewが再描画される。実装方法によっては初期化されてしまう
//
// ref: https://tokizuoh.dev/posts/td152tqrb7iflicp/
// ref: https://note.com/taatn0te/n/n1fc0518a8ee6
//  ref: https://zenn.dev/usk2000/articles/7a05caaa1dd920
//  ref: https://zenn.dev/yorifuji/articles/swiftui-manage-observableobject

import SwiftUI

struct CounterView: View {
    @State var counter = 0
    @State var counter2 = 0  // 追加
    
    var body: some View {
        VStack(alignment: .leading, spacing: 50) {
            HStack {
                Text("counter: \(counter)")
                Button("+") {
                    counter += 1
                }
                Button("■") { // このcounter2の値をCounterViewで使わない限り、ObservedObjectCounterが再描画されるようなことも特になかった
                    counter2 += 1  // 追加
                }
            }
            StateObjectCounter()
            ObservedObjectCounter()
        }
    }
}

final class Counter: ObservableObject {
    @Published var number = 0
}

struct StateObjectCounter: View {
    @StateObject private var counter = Counter()
    
    var body: some View {
        HStack {
            Text("StateObjectCounter: \(counter.number)")
            Button("+") {
                counter.number += 1
            }
        }
    }
}

struct ObservedObjectCounter: View {
    @ObservedObject private var counter = Counter()
    
    var body: some View {
        HStack {
            Text("ObservedObjectCounter: \(counter.number)")
            Button("+") {
                counter.number += 1
            }
        }
    }
}
