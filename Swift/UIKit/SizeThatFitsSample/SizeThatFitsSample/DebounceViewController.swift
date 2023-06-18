//
//  DebounceViewController.swift
//  SizeThatFitsSample
//
//  Created by s_yamada on 2022/12/10.
//

import UIKit
import Combine


/*
 PracticalCombineでやったSearchFeatureの簡易版

 */
class DebounceViewController: UIViewController, UITextFieldDelegate {
    private lazy var textField: UITextField = {
        // UITextFieldの配置するx,yと幅と高さを設定.
           let tWidth: CGFloat = 200
           let tHeight: CGFloat = 30
           let posX: CGFloat = (self.view.bounds.width - tWidth)/2
           let posY: CGFloat = (self.view.bounds.height - tHeight)/2

           // UITextFieldを作成する.
        let textField = UITextField(frame: CGRect(x: posX, y: posY, width: tWidth, height: tHeight))

           // 表示する文字を代入する.
        textField.text = "Hello TextField"

           // Delegateを自身に設定する
        textField.delegate = self

           // 枠を表示する.
        textField.borderStyle = .roundedRect

           // クリアボタンを追加.
        textField.clearButtonMode = .whileEditing

           // Viewに追加する
        return textField
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 10)
        label.textColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .gray
        return label
    }()
    
    @Published
    var searchQuery: String?
    
    var cancellables = Set<AnyCancellable>()
    var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        testttt()
        
        view.addSubview(label)
        view.addSubview(textField)
        
        let centerX = label.centerXAnchor.constraint(equalTo:  view.centerXAnchor, constant: 0)
        let centerY = label.centerYAnchor.constraint(equalTo:  view.centerYAnchor, constant: 100)
        let labelHeight = label.heightAnchor.constraint(equalToConstant: 100)
        let labelWidth = label.widthAnchor.constraint(equalToConstant: 300)
        

        NSLayoutConstraint.activate([centerX, centerY, labelHeight, labelWidth])
        
        
        // a bunch of setup code
        
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        /*
         スロットルについて理解した
         
        $searchQuery.throttle(for: 10, scheduler: DispatchQueue.main, latest: true) // 値を送ったところから新しくintervalに設定した秒数のカウントが始まる
            .filter({ ($0 ?? "").count > 2}) // スロットルの場合最初からfilterとremoveDuplicateを使うと挙動が理解しづらいからまずはつけずに動かして理解してみて、その後にこの二つをつけた場合の挙動を理解すると完全に理科した！になる
            .removeDuplicates()
            .print()
            .assign(to: \.text, on: label)
            .store(in: &cancellables)
         
                 $searchQuery
                     .debounce(for: 1, scheduler: DispatchQueue.main)
                     .filter({ ($0 ?? "").count > 2})
                     .removeDuplicates()
                     .print()
                     .assign(to: \.text, on: label)
                     .store(in: &cancellables)
         */
        
             cancellable = Timer.publish(every: 2.0, on: .main, in: .default)
                 .autoconnect()
                 .print("\(Date().description)")
                 .throttle(for: 10.0, scheduler: DispatchQueue.main, latest: false)
                 .sink(
                     receiveCompletion: { print ("Completion: \($0).") },
                     receiveValue: { print("ラスト \($0).") }
                  )
    }
    
    @objc func textChanged() {
        searchQuery = textField.text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
           if (self.textField.isFirstResponder) {
               self.textField.resignFirstResponder()
           }
       }
       
       // 改行ボタンを押してキーボードを閉じる
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           
           // キーボードを隠す
           textField.resignFirstResponder()
           return true
       }
       // クリアボタンが押された時の処理
       func textFieldShouldClear(_ textField: UITextField) -> Bool {
           
//           print("Clear")
           return true
       }
       
       // テキストフィールドがフォーカスされた時の処理
       func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//           print("Start")
           return true
       }
       
       // テキストフィールドでの編集が終わろうとするときの処理
       func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//           print("End")
           return true
       }
}



class ListNode {
    var val: Int
    var next: ListNode?
    init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

class Solution {
    func hasCycle(_ head: ListNode?) -> Bool {
        if head == nil {
            return false
        }
        var set = Set<ObjectIdentifier>()
        var root = head

        while let cur = root {
            let id = ObjectIdentifier(cur)

            if set.contains(id) {
                return true
            } else {
                set.insert(id)
                root = cur.next
            }
        }

        return false
    }
}

func testttt() {

    // 循環リンクリストの作成
    let node1 = ListNode(1)
    let node2 = ListNode(2)
    let node3 = ListNode(3)
    let node4 = ListNode(4)

    node1.next = node2
    node2.next = node3
    node3.next = node4
    node4.next = node2  // 循環を作成


    let solution = Solution()
    let result = solution.hasCycle(node1)
    print(result)

}
