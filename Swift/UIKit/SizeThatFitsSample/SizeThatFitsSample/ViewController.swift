//
//  ViewController.swift
//  SizeThatFitsSample
//
//  Created by s_yamada on 2022/09/27.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "dfadsfdsfadfdasfadsfdsfas\n dfdsfadsfadfasdfadsf \n fdfadfadsfasdf "
        label.font = .systemFont(ofSize: 10)
        label.textColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        view.addSubview(label)
    
        let centerX = label.centerXAnchor.constraint(equalTo:  view.centerXAnchor, constant: 0)
        let centerY = label.centerYAnchor.constraint(equalTo:  view.centerYAnchor, constant: 0)
 
        NSLayoutConstraint.activate([centerY, centerX])
        
        print(label.getTextHeight())
        // 自前で文字列の高さ計算(makeSize)を作らなくてもsizeThatFitsあるから必要なかった
        // https://kimagureneet.hatenablog.com/entry/2017/01/15/225623
        // https://qiita.com/ryogo_niwa/items/7073d2dfee2a0e8a2132
        print(label.sizeThatFits(.init(width: label.bounds.width, height: .infinity)))
        print(label.intrinsicContentSize)
    }


}
/*
 Autolayout使用時の幅が分かっているときの高さの計算方法
 https://medium.com/eureka-engineering/bridging-autolayout-and-custom-layout-998889fab930
 https://qiita.com/maoyama/items/6ae0feebf540ebe1b4a8
 
 
 ## sizeThatFitsとsystemLayoutSizeFittingの違い
 
 > Returns the optimal size of the view based on its current constraints.
 
 上記の公式引用文によればsystemLayoutSizeFittingは制約に基づいてViewのサイズを返すから、autolayoutを設定していてその制約に基づいてサイズを返して欲しいときはsystemLayoutSizeFittingを使って、制約ではなくて中身のコンテンツ量に応じたサイズを計算してもらって返して欲しいときはsizeThatFitsを使うのかな
 
 ⇨ ViewDidLoadで書いてるコードを以下に変えてみたら違いがわかった
 元のコードは高さの制約を付けてなかったからつけてみたら、sizeThatFitsとsystemLayoutSizeFittingで返すサイズが違った
 ⇨ sizeThatFitsは制約を無視して実際のコンテンツ量に応じた高さを返した
 ⇨ 一方でsystemLayoutSizeFittingは公式ドキュメントに書いてあるとおり制約で設定した高さを返した
 
 
 override func viewDidLoad() {
     super.viewDidLoad()
     view.backgroundColor = .white
     let label = UILabel()
     label.numberOfLines = 0
     label.text = "dfadsfdsfadfdasfadsfdsfas\n dfdsfadsfadfasdfadsf \n fdfadfadsfasdf "
     label.font = .systemFont(ofSize: 10)
     label.textColor = .blue
     label.translatesAutoresizingMaskIntoConstraints = false
     label.backgroundColor = .red
     view.addSubview(label)
 
     let centerX = label.centerXAnchor.constraint(equalTo:  view.centerXAnchor, constant: 0)
     let centerY = label.centerYAnchor.constraint(equalTo:  view.centerYAnchor, constant: 0)
     let height = label.heightAnchor.constraint(equalToConstant: 100)

     NSLayoutConstraint.activate([centerY, centerX, height])
     
     print(label.getTextHeight())
 
     print(label.sizeThatFits(.init(width: label.bounds.width, height: .infinity)))
     print(label.systemLayoutSizeFitting(.init(width: label.bounds.width, height: UIView.layoutFittingCompressedSize.height)))
     print(label.intrinsicContentSize)
 }
 
 

*/
