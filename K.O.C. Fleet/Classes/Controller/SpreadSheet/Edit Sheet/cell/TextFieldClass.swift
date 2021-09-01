//
//  TextFieldClass.swift
//  K.O.C. Fleet
//
//  Created by Ahmad Shaheer on 24/07/2021.
//

import Foundation
import SpreadsheetView
import UIKit

class TextFieldClass: Cell, UITextFieldDelegate {
    
    
    //MARK: - Variables
    
    static let identifier = "TextFieldClass"
    let label = UITextField()
    
    
    //MARK: - Override function
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.delegate = self
    }
    
    
    //MARK: - Public function
    public func setup(with text: String) {
        label.text = text
        label.textAlignment = .center
        contentView.addSubview(label)
        label.font = label.font?.withSize(12)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    public func setLabelBackgroundColor(with color: UIColor) {
        label.backgroundColor = color
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            //myvalidator(text: updatedText)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text!)
    }
    
}
