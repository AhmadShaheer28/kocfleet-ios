//
//  LabelClass.swift
//  K.O.C. Fleet
//
//  Created by Ahmad Shaheer on 12/07/2021.
//

import Foundation
import SpreadsheetView
import UIKit

class LabelClass: Cell {
    
    
    //MARK: - Variables
    
    static let identifier = "LabelClass"
    private let label = UILabel()
    
    
    //MARK: - Override function
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = contentView.bounds
    }
    
    
    //MARK: - Public function
    public func setup(with text: String) {
        label.text = text
        label.textAlignment = .center
        contentView.addSubview(label)
        label.font = label.font.withSize(12)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.minimumScaleFactor = 7
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
    }
    
    public func setLabelBackgroundColor(with color: UIColor) {
        label.backgroundColor = color
    }
        
    
}
