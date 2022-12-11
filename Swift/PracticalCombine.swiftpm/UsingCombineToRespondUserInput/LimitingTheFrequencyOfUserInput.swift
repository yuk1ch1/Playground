//
//  File.swift
//  
//
//  Created by s_yamada on 2022/12/09.
//

/*
 operator
 - debounce
 - filter
 - removeDuplicate
 - print
 
 - throttle
 */

import UIKit
import Combine


// textFieldに何かを入力して検索することを想定
class DebounceViewController: UIViewController, UITextFieldDelegate {
    private lazy var textField: UITextField = {
        let tWidth: CGFloat = 200
        let tHeight: CGFloat = 30
        let posX: CGFloat = (self.view.bounds.width - tWidth)/2
        let posY: CGFloat = (self.view.bounds.height - tHeight)/2
        let textField = UITextField(frame: CGRect(x: posX, y: posY, width: tWidth, height: tHeight))
        textField.text = "Hello TextField"
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(label)
        view.addSubview(textField)
        
        let centerX = label.centerXAnchor.constraint(equalTo:  view.centerXAnchor, constant: 0)
        let centerY = label.centerYAnchor.constraint(equalTo:  view.centerYAnchor, constant: 100)
        let labelHeight = label.heightAnchor.constraint(equalToConstant: 100)
        let labelWidth = label.widthAnchor.constraint(equalToConstant: 300)
        

        NSLayoutConstraint.activate([centerX, centerY, labelHeight, labelWidth])
        
        
        // a bunch of setup code
        
        textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        
        $searchQuery
            .debounce(for: 0.3, scheduler: DispatchQueue.main) // 全部に反応せずにユーザーが考えながら入力していることを想定
            .filter({ ($0 ?? "").count > 2}) // 何かを検索する時は１文字入力して検索ってことはなさそうだ体痛い3文字以上ワードを入力したら検索することを想定した
            .removeDuplicates() // 入力、ポーズ、追加でちょっと入力したけどやっぱり違ったから追加分を削除して元々入力したワードに戻った場合に再度同じワードで検索が走るような重複を省いて無駄なAPIリクエストが実行されないように
            .print()
            .assign(to: \.text, on: label)
            .store(in: &cancellables)
    }
    
    @objc func textChanged() {
        searchQuery = textField.text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
           if (self.textField.isFirstResponder) {
               self.textField.resignFirstResponder()
           }
       }
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           
           textField.resignFirstResponder()
           return true
       }

       func textFieldShouldClear(_ textField: UITextField) -> Bool {
           
           return true
       }
       
       func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
           return true
       }
       
       func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
           return true
       }
}
