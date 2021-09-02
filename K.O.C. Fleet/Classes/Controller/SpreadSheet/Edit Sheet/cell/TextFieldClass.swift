//
//  TextFieldClass.swift
//  K.O.C. Fleet
//
//  Created by Ahmad Shaheer on 24/07/2021.
//

import Foundation
import SpreadsheetView
import UIKit

class TextFieldClass: Cell {
    
    
    //MARK: - Variables
    
    static let identifier = "TextFieldClass"
    let label = UITextField()
    private var index = -1
    var delegate: TextfieldChangedText?
    
    
    //MARK: - Override function
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    //MARK: - Public function
    public func setup(with text: String, _ index: Int) {
        label.text = text
        label.textAlignment = .center
        contentView.addSubview(label)
        label.font = label.font?.withSize(12)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.index = index
        label.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    public func setLabelBackgroundColor(with color: UIColor) {
        label.backgroundColor = color
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text {
            delegate?.onTextChanged(to: text, at: index)
        }
    }
    
}
