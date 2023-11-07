//
//  SearchBarView.swift
//  TreeSwift
//
//  Created by 冯子丰 on 2023/11/6.
//

import Foundation
import UIKit

class SearchBarView: UIView {
    
    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton.init(frame: CGRect(x: ScreenWidth - 88, y: StateBarH + 2, width: 88, height: 40))
        cancelButton.setTitle("取消", for: UIControl.State.normal)
        cancelButton.setTitleColor(HexColor(value: 0x2D3035), for: UIControl.State.normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelButton.addTarget(self, action: #selector(clickCancal), for: UIControl.Event.touchUpInside)
        
        return cancelButton
    }()
    
    lazy var textField: SearchTextField = {
        let textFlied = SearchTextField.init(frame: CGRect(x: 15, y: self.cancelButton.top, width: self.cancelButton.left - 15, height: self.cancelButton.height))
        textFlied.delegate = self
//        textFlied.deleteAll = deleteAll
        return textFlied
        
    }()
    
    var reloadResultView: ((String) -> ())?
    
//    var deleteAll: (() -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = HexColor(value: 0xf2f3f5)
        self.addSubview(textField)
        self.addSubview(cancelButton)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func clickCancal(){
        let appdelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.nav?.popViewController(animated: false)
    }
}

extension SearchBarView :UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.count == 0) {return true}
        if (reloadResultView != nil){
            reloadResultView!(textField.text!)
        }
        textField.endEditing(true)
        return true;
    }
}
