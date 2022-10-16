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

import SwiftUI

struct CounterView: View {
    @State var counter = 0
    var body: some View {
        VStack(alignment: .leading, spacing: 50) {
            HStack {
                Text("counter: \(counter)")
                Button("+") {
                    counter += 1
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
