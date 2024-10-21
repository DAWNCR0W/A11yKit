//
//  UITextField+A11y.swift
//  A11yKit
//
//  Created by dawncr0w on 10/21/24.
//

import UIKit

public extension UITextField {
    func a11y_optimizeForDynamicType() {
        adjustsFontForContentSizeCategory = true
        if let customFont = font {
            font = UIFontMetrics.default.scaledFont(for: customFont)
        } else {
            font = UIFont.preferredFont(forTextStyle: .body)
        }
    }
    
    func a11y_setAccessibleFont(style: UIFont.TextStyle = .body) {
        font = UIFont.preferredFont(forTextStyle: style)
        adjustsFontForContentSizeCategory = true
    }
    
    func a11y_optimizeContrast() {
        guard let textColor = textColor,
              let backgroundColor = backgroundColor ?? superview?.backgroundColor else { return }
        
        let minimumContrastRatio = A11yKit.shared.configuration.minimumContrastRatio ?? 4.5 // WCAG AA
        let currentContrast = textColor.contrastRatio(with: backgroundColor)
        if currentContrast < minimumContrastRatio {
            self.textColor = textColor.adjustedForContrast(against: backgroundColor, targetContrast: minimumContrastRatio)
        }
    }
    
    func a11y_makeAccessible(prefix: String = "", suffix: String = "", fallbackText: String = "Text Field", traits: UIAccessibilityTraits = .none) {
        let textFieldText = placeholder ?? text ?? fallbackText
        a11y_makeAccessible(label: prefix + textFieldText + suffix, traits: traits)
    }
    
    func a11y_setAccessiblePlaceholder(_ placeholder: String, color: UIColor? = nil) {
        var attributes: [NSAttributedString.Key: Any] = [.accessibilitySpeechPunctuation: true]
        if let color = color {
            attributes[.foregroundColor] = color
        }
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: attributes)
    }
}
