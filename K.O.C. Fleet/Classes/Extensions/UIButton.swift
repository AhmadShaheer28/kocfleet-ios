//
//  UIButton.swift
//

import UIKit
import Localize_Swift

extension UIButton
{
    func applyGradient(colors: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBInspectable
    var checkLanguage: Bool {
        
        get {
            return true
        }
        
        set {
            
            if newValue && Localize.currentLanguage() == "ar" {
                var edgeInsets = self.imageEdgeInsets
                swap(&edgeInsets.left, &edgeInsets.right)
                self.imageEdgeInsets = edgeInsets
                
                var titleInsets = self.titleEdgeInsets
                swap(&titleInsets.left, &titleInsets.right)
                self.titleEdgeInsets = titleInsets
                self.imageView?.transform = CGAffineTransform(scaleX: -1, y: 1)
            }
        }
    }
}

