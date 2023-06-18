//
//  Observability.swift
//  WWDC2023
//
//  Created by s_yamada on 2023/06/17.
//

import SwiftUI
import Observation

/*
 @StateObject → @State
 @ObservableObject → @Bindable or 単なるプロパティになった
 @EnvironmentObject → @Environment
 になった
 */

@Observable struct Model {
    var i = 0
}

@Observable class Model2 {
    var i = 0
}

@Observable class Model3 {
    var i = 0
}

@Observable class Model4 {
    var text = ""
}

struct ContentView: View {
    // Observableのインスタンスに@StateをつければModel自体はclassでもstructでも関係ない
    @State var model = Model()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

            Text(model.i, format: .number)

            Button("Increment") {
                model.i += 1
//                print(ObjectIdentifier(model))

                withUnsafeMutablePointer(to: &model) { memoryAddress in
                    print(memoryAddress)
                }

            }

        }
        .padding()
    }
}

struct ContentView2: View {
    // @Obsevableがclassに対してついてる場合は、そのインスタンスを生成するところで@Stateをつけずに単なるプロパティとして持たせても監視して更新される。参照型のため。
    // ただしObservableがstructに対してついてる場合は、@Stateがついてないのでstruct自体はimmutaleであるためコンパイルエラー
    let model = Model2()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

            Text(model.i, format: .number)

            Button("Increment") {
                model.i += 1
            }
        }
        .padding()
    }
}

struct ContentView3: View {
    @State var model = Model3()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

            NestedView()
                .environment(model)
        }
        .padding()
    }
}

struct NestedView: View {
    @Environment(Model3.self) var model: Model3

    var body: some View {
        Text(model.i, format: .number)

        Button("Increment") {
            model.i += 1
        }

    }
}

struct ContentView4: View {
    @State var model = Model4()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)

            BindedView(model: model)
        }
        .padding()
    }
}

struct BindedView: View {
    @Bindable var model: Model4

    var body: some View {
        TextField(text: $model.text) {
            Text("Label")
        }
    }
}

// observationは別にSwiftUIの機能というわけではないからUIKitでも使える


#Preview {
//    ContentView()
//    ContentView2()
//    ContentView3()
    ContentView4()
}
