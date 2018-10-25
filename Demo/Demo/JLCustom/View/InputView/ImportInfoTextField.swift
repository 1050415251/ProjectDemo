//
//  ImportInfoTextField.swift
//  GTEDai
//
//  Created by 国投 on 2018/1/18.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation
import UIKit

class ImportInfoTextField:UITextField,UITextFieldDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let info = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if (textField.isSecureTextEntry) {
            textField.text = info
            return false
        }
        return true
    }
    
}



















