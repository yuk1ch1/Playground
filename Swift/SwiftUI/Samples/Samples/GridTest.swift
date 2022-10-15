//
//  GridTest.swift
//  Samples
//
//  Created by s_yamada on 2022/10/15.
//

import SwiftUI

struct GridTest: View {
    var body: some View {
        // iOS16以上からこれができる。それまでは面倒だったらしい
        Grid(alignment: .leading) {
            GridRow {
                Text("Label 1")
                    .padding()
                    .border(.mint)
                
                Text("Value")
                    .padding()
                    .border(.purple)
            }
            
            GridRow {
                Text("Label Label Label")
                    .padding()
                    .border(.yellow)
                
                Text("Value Value")
                    .padding()
                    .border(.red)
            }
        }
    }
}
struct MyView: View {
    var body: some View {
        ViewThatFits {
            Color.pink.frame(width: 1200)
                .transition(.move(edge: .leading))
            Color.yellow.frame(width: 400)
                .transition(.move(edge: .leading))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MyView()
    }
}


func test() {
    ForEach(0...10, id: \.self) { dummy in
        Text("fdfa")
            .id(dummy.self)
    }
}
