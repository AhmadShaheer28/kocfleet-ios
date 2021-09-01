//
//  UIFont.swift
//

import UIKit

extension UIFont {
    
    class func font(withSize: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Regular", size: withSize)!
    }
    
    class func semiBoldFont(withSize: CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-SemiBold", size: withSize)!
    }
}
