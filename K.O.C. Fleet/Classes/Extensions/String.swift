//
//  File.swift
//

import Foundation
import  UIKit

extension String {
    
    var isValidEmail: Bool {
       let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
       let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
       return testEmail.evaluate(with: self)
    }
    
    func returnColor() -> UIColor? {
        switch(self){
        case "Red":
            return UIColor.red
        case "Black":
            return UIColor.black
        case "Blue":
            return UIColor.blue
        case "Yellow":
            return UIColor.yellow
        case "Pink":
            return UIColor.systemPink
        case "Gray":
            return UIColor.gray
        case "White":
            return UIColor.white
        case "Cyan":
            return UIColor.cyan
        case "Green":
        return UIColor.green
        default:
            return nil
        }
    }
    
    func isEmptyOrWhitespace() -> Bool {
        if self.isEmpty {
            return true
        }
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}
