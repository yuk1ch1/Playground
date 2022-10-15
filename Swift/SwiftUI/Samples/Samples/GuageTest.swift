//
//  ContentView.swift
//  Samples
//
//  Created by s_yamada on 2022/10/15.
//

import SwiftUI
import Combine

struct SimpleGauge: View {
    @State private var batteryLevel = 0.4
    
    var body: some View {
        VStack {
            Gauge(value: batteryLevel) {
                Text("Battery Level")
            }
            
            Gauge(value: 0.5, in: 0...1) {
                Text("50%")
            }
            .gaugeStyle(.accessoryCircularCapacity) // ロック画面にウィジェット表示する時とかに使う
            .tint(.pink)
            
            Gauge(value: 0.5, in: 0...1) {
                Text("0 100")
            }
            .gaugeStyle(.accessoryCircular)
            .tint(.green)
            .overlay(Text("50%"))
            
            Spacer()
                .frame(height: 100)
            
            HStack(spacing: 100) {
                Gauge(value: 0.5, in: 0...1) {
                    Text("Label")
                } currentValueLabel: {
                    Text("50%")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("100")
                }
                .scaleEffect(2.0) // frameだとサイズ変更できなかったけどscaleEffectを使うことでサイズを変更できた。ただしここを固定値ではなくて描画領域に応じて動的に変更できるようにしたい
                .gaugeStyle(.accessoryCircular) // prefixがaccessoryのものは元々ウィジェット用
                .tint(.yellow)
                
                Gauge(value: 0.5, in: 0...1) {
                } currentValueLabel: {
                    Text(0.5, format: .percent)
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("100")
                }
                .gaugeStyle(.accessoryCircular)
                .scaleEffect(2.0)
                .tint(Gradient(colors: [.red, .yellow, .green, .green, .green]))
            }
            Spacer()
                .frame(height: 100)
            
            ProgressView(value: 0.5, total: 1) {
                Text("Progress")
                    .frame(maxWidth: .infinity, alignment: .center)
//                    .background(Color.red)
            }
        }
        
        
    }
}

struct GaugeView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleGauge()
    }
}

struct ScalingGauge: View {
    var value = 0.5
    @State private var scale = 1.0
    @State private var padding = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("accessoryCircularCapacity")
                    .font(.title)
                
                Gauge(value: value) {
                    Text(value, format: .percent)
                }
                .gaugeStyle(.accessoryCircularCapacity)
                .scaleEffect(scale)
                .tint(.green)
                .background(GeometryReader { inner -> Text in
                    DispatchQueue.main.async {
                        let diameter = geometry.size.width// * 0.8
                        scale = diameter / inner.size.width
                        padding = (diameter - inner.size.width) / 2
                    }
                    return Text("")
                })
                .padding(padding)
                .background(Color.gray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // GeometryReaderを使用するとセンタリングされない問題があるのでそれに対処
        }
    }
}

// ref: https://qiita.com/yuppejp/items/94ff29a2fe982a7c2f7b
struct AnimationScalingGauge: View {
    @State private var scale = 1.0
    @State private var padding = 0.0
    @State private var value = 0.0
    @State private var inputValue = 50.0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack {
                    Text("accessoryCircularCapacity")
                        .font(.title)
                    
                    Gauge(value: value, in: 0...100) {
                        Text(value / 100, format: .percent)
                    }
                    .gaugeStyle(.accessoryCircularCapacity)
                    .scaleEffect(scale)
                    .tint(.green)
                    .background(GeometryReader { inner -> Text in
                        DispatchQueue.main.async {
                            let diameter = geometry.size.width// * 0.8
                            scale = diameter / inner.size.width
                            padding = (diameter - inner.size.width) / 2
                            
                            print("***** geometry: \(geometry.size.width), \(geometry.size.height)")
                            print("***** inner   : \(inner.size.width), \(inner.size.height)")
                            print("***** scale   : \(scale)")
                            
                        }
                        return Text("")
                    })
                    .padding(padding)
                    .background(Color.gray)
                }
                VStack {
                    Text("accessoryLinear")
                    Gauge(value: value, in: 0...100) {}
                        .gaugeStyle(.accessoryLinear)
                        .tint(.accentColor)
                    
                    Text("accessoryLinearCapacity")
                    Gauge(value: value, in: 0...100) {}
                        .gaugeStyle(.accessoryLinearCapacity)
                        .tint(.cyan)
                    
                    Text("linearCapacity")
                    Gauge(value: value, in:0...100) {}
                        .gaugeStyle(.linearCapacity)
                        .tint(.orange)
                }
                Spacer()
                Slider(value: $inputValue, in: 0...100)
                Text(String(value))
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1)) {
                    value = inputValue
                }
            }
            .onChange(of: inputValue) { newValue in
                withAnimation(.easeInOut(duration: 1)) {
                    value = newValue.rounded(.toNearestOrAwayFromZero) // rountedを使ってintに。引数にtoNearestOrAwayFromZeroを渡すことで四捨五入される
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // GeometryReaderを使用するとセンタリングされない問題があるのでそれに対処
        }
    }
}

struct ScalingGauge_Previews: PreviewProvider {
    static var previews: some View {
        AnimationScalingGauge()
    }
}
