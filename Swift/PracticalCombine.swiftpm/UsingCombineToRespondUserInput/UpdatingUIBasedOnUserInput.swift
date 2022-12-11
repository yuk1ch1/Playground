//
//  File.swift
//  
//
//  Created by s_yamada on 2022/12/09.
//

import Foundation
import UIKit
import Combine

/*
 operator
 - なし
 
 従来のUIKit⇨Combine⇨SwiftUIと進むにつれて変更に強いコードになっていることが説明されていた
 */

fileprivate class ViewController: UIViewController {
    let slider = UISlider()
    let label = UILabel()
    
    @Published
    var sliderValue: Float = 0.5
    
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(slider)
        view.addSubview(label)
        
        $sliderValue
            .map({ value in
                "Slider is at \(value)"
            })
            .assign(to: \.text, on: label)
            .store(in: &cancellables)
        
        
        $sliderValue
            .assign(to: \.value, on: slider)
            .store(in: &cancellables)
        
        slider.addTarget(self, action: #selector(updateLabel), for: .valueChanged)
    }
    
    @objc func updateLabel() {
        sliderValue = slider.value // CombineにはSlider向けにtwo-way bindingが用意されてないのでやはりsliderValueの更新は独自にやらないといけない
    }
}

import SwiftUI

/*
 SwiftUIには上記のSliderに対するCombineの問題を解決するソリューションが用意されている(以下参照)
 */

fileprivate struct ExampleView: View {
  @State private var sliderValue: Float = 50

  var body: some View {
    VStack {
      Text("Slider is at \(sliderValue)")
      Slider(value: $sliderValue, in: (1...100))
    }
  }
}
