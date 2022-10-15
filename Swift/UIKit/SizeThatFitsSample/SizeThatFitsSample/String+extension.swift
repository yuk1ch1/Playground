//
//  String+extension.swift
//  SizeThatFitsSample
//
//  Created by s_yamada on 2022/09/27.
//

import UIKit

/// Autolayoutを使わずにUILabelの高さを計算する方法
///
/// Ref: (https://qiita.com/Yaruki00/items/fefcde63fe60526f6ff7)
extension String {
    
    /// 文字列の高さ計算
    func makeSize(width: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGSize {
        // 高さは最大の値を取る *ただしinfinityよりは小さい
        // でもこれinfinityでいいんじゃない？
        let bounds = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        // 文字描画オプションの設定。boundingRectの公式ドキュメントによれば複数行の高さの計算を正確にするにはusesLineFragmentOriginが必要。
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        
        // boundingRectは文字列の描画領域を計算するメソッド
        let rect = self.boundingRect(with: bounds, options: options, attributes: attributes, context: nil)
        // boundingRectの公式ドキュメントに書かれている通り、boundingRectが返す値はceilによって小数点をきりあげる
        let size = CGSize(width: ceil(rect.size.width), height: ceil(rect.size.height))
        return size
    }
}

// UILabelの高さ計算。自身の幅と属性を上記のメソッドに渡してやるだけ
extension UILabel {
    func getTextHeight() -> CGFloat {
        guard let text = text else { return 0.0 }
        let attributes: [NSAttributedString.Key: Any] = [.font : font]
        let size = text.makeSize(width: bounds.width, attributes: attributes)
        return size.height
    }

      func getAttributedTextHeight() -> CGFloat {
          guard let attributedText = self.attributedText else {
              return 0.0
          }
          var attributes: [NSAttributedString.Key: Any] = attributedText.attributes(at: 0, effectiveRange: nil)
          attributes[.font] = self.font
          let size = attributedText.string.makeSize(width: self.bounds.width, attributes: attributes)
          return size.height
      }
}
