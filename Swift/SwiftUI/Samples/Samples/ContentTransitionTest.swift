//
//  ContentTransitionTest.swift
//  Samples
//
//  Created by s_yamada on 2022/10/15.
//

import SwiftUI

struct AnimationView: View {
    @State private var flag = false
    
    var body: some View {
        let _ = Self._printChanges()
        
        VStack {
            let _ = Self._printChanges()
            Text("1000")
                .fontWeight(flag ? .black : .light)
                .foregroundColor(flag ? .yellow : .red)
            
            //        }
                .onTapGesture {
                    let _ = Self._printChanges()
                    withAnimation(.default.speed(0.5)) {
                        flag.toggle()
                    }
                }
                .padding() // onTapgestureのタップ領域はpaddingつけるとわかった
                .background(Color.purple)
            
            VStack {
                // flagでの出しわけをしていなくてもonTapGestureの処理が実行されるたびにここも再度呼び出される
                // だからSwiftUIではなるべく余計なレンダリングが実行されないようにクラスを細かく分ける必要がある
                Text("ダミー")
                Text("ダミー")
            }
        }
    }
}


struct AnimationView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationView()
    }
}

struct ContentTransitionView: View {
    @State private var flag = false
    
    @State private var text = "abcdef"
    
    @State private var i = 100
    
    var body: some View {
        VStack {
            Text(verbatim: "\(i)")
                .fontWeight(flag ? .black : .light)
                .foregroundColor(flag ? .yellow : .red)
        }
        .contentTransition(.numericText(countsDown: true))
        .onTapGesture {
            let _ = Self._printChanges()
            withAnimation(.default.speed(0.5)) {
//                flag.toggle()
//                text = "ghijklm"
                i += 1
            }
        }
    }
}

struct ContentTransitionView_Previews: PreviewProvider {
    static var previews: some View {
        ContentTransitionView()
    }
}
