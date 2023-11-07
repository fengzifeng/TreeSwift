//
//  SearchTextField.swift
//  TreeSwift
//
//  Created by 冯子丰 on 2023/11/6.
//

import Foundation
import UIKit

class SearchTextField: UITextField{
    var deleteAll: (() -> ())?

    lazy var deleteButton: UIView = {
        let deleteButton = UIView.init(frame: CGRect(x: self.width - 40, y: (self.height - 30)/2.0, width: 40, height: 30))
        let size: CGSize = UIImage(named: "search_close")!.size
        let imageView: UIImageView = UIImageView(frame: CGRect(x: (deleteButton.width - size.width)/2.0, y: (deleteButton.height - size.height)/2.0, width: size.width, height: size.height))
        imageView.image = UIImage(named: "search_close")
        deleteButton.addSubview(imageView)
        let tap:  UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(clickDelete))
        deleteButton.addGestureRecognizer(tap)
        deleteButton.isHidden = true
        
        return deleteButton
    }()
    
    var textStr: String?{
        set{
            text = newValue
            if (self.text!.count>0) {
                self.deleteButton.isHidden = false;
            } else {
                self.deleteButton.isHidden = true;
            }
            
        } get{
            return self.text
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration()
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(not:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configuration() {
        self.leftViewMode = UITextField.ViewMode.always
        let iconimageView: UIImageView = UIImageView.init(image: UIImage(named: "search_icon"))
        self.leftView = iconimageView
        self.rightViewMode = UITextField.ViewMode.always
        self.rightView = self.deleteButton
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.height/2.0
        self.backgroundColor = UIColor.white
        self.font = UIFont.systemFont(ofSize: 14)
        self.textColor = HexColor(value: 0x2D3035)
        
        let arrStr:  NSMutableAttributedString = NSMutableAttributedString.init(string: "搜索文章",attributes: [NSAttributedString.Key.foregroundColor:HexColor(value: 0x8D8E91)])
        self.attributedPlaceholder = arrStr;
        self.returnKeyType = UIReturnKeyType.search;
        self.enablesReturnKeyAutomatically = true;
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var iconRect = super.leftViewRect(forBounds: bounds)
        iconRect.origin.x += 12
        return iconRect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var editingRect = super.editingRect(forBounds: bounds)
        editingRect.origin.x += 10
    //    editingRect.size.width = self.width - editingRect.origin.x - 31;
        return editingRect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.textRect(forBounds: bounds)
        textRect.origin.x += 10
    //    textRect.size.width = self.width - textRect.origin.x - 31;
        return textRect
    }
    
    @objc func textFieldDidChange(not: NSNotification){
        let textF: UITextField = not.object as! UITextField
        
        if (textF == self) {
            if (self.text!.count>0) {
                self.deleteButton.isHidden = false;
            } else {
                self.deleteButton.isHidden = true;
                if(self.deleteAll != nil){
                    self.deleteAll!()
                }
            }
        }
    }
    
    
    
    @objc func clickDelete(){
        if (self.text?.count == 0) {return}
        self.text = "";
        if(self.deleteAll != nil){
            self.deleteAll!()
        }
        self.deleteButton.isHidden = true;
    }
    
}
