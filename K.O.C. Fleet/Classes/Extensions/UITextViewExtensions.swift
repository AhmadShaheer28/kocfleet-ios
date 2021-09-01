// UITextViewExtensions.swift - Copyright 2020 SwifterSwift

#if canImport(UIKit) && !os(watchOS)
import UIKit
import Localize_Swift

// MARK: - Methods

public extension UITextView {
    /// SwifterSwift: Clear text.
    func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }

    /// SwifterSwift: Scroll to the bottom of text view.
    func scrollToBottom() {
        let range = NSRange(location: (text as NSString).length - 1, length: 1)
        scrollRangeToVisible(range)
    }

    /// SwifterSwift: Scroll to the top of text view.
    func scrollToTop() {
        let range = NSRange(location: 0, length: 1)
        scrollRangeToVisible(range)
    }

    /// SwifterSwift: Wrap to the content (Text / Attributed Text).
    func wrapToContent() {
        contentInset = .zero
        scrollIndicatorInsets = .zero
        contentOffset = .zero
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        sizeToFit()
    }
}

public extension UITextView {
    @IBInspectable
    var checkLanguage: Bool {
        
        get {
            return true
        }
        
        set {
            if Localize.currentLanguage() == "ar" {
                self.textAlignment = .right
            }
            else {
                self.textAlignment = .left
            }
            
        }
    }
}

#endif
