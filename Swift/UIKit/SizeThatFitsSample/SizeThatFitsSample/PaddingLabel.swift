//
//  PaddingLabel.swift
//  SizeThatFitsSample
//
//  Created by s_yamada on 2022/09/27.
//

import UIKit
import SwiftUI

// 内部に余白を持ったUILabel
class PaddingLabel: UILabel {
    // この値を変えることでLabelないのpaddingを変更する
    let padding: UIEdgeInsets = .zero //.init(top: 50, left: 50, bottom: 50, right: 50)

    // テキストの描画範囲を余白のInsetを加えたものにする
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    // Intrinsic Content Sizeを余白のInset加えたものにする
    override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.height += padding.top + padding.bottom
        intrinsicContentSize.width += padding.left + padding.right
        return intrinsicContentSize
    }
}

struct Wrap<T: UIView>: UIViewRepresentable {
    var uiView: T
    func makeUIView(context: Context) -> T { uiView }
    func updateUIView(_ view: T, context: Context) {}
}


struct PaddingLabel_Previews: PreviewProvider {
    static var previews: some View {
        let label = PaddingLabel()
        label.text = "dfadsfdsfadfdasfadsfdsfas"
        label.font = .systemFont(ofSize: 10)
        label.textColor = .blue
        label.backgroundColor = .red
        let view = Wrap(uiView: label)
        return view
            .fixedSize()
            .previewLayout(.sizeThatFits)
    }
}
