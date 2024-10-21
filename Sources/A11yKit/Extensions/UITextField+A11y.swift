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
        }
    }
    
    func a11y_setAccessibleFont(style: UIFont.TextStyle = .body) {
        font = UIFont.preferredFont(forTextStyle: style)
        adjustsFontForContentSizeCategory = true
    }
    
    func a11y_optimizeContrast() {
        guard let textColor = textColor,
              let backgroundColor = backgroundColor ?? superview?.backgroundColor else { return }
        
        let currentContrast = textColor.contrastRatio(with: backgroundColor)
        if currentContrast < A11yKit.shared.configuration.minimumContrastRatio {
            self.textColor = textColor.adjustedForContrast(against: backgroundColor, targetContrast: A11yKit.shared.configuration.minimumContrastRatio)
        }
    }
    
    func a11y_makeAccessible(prefix: String = "", suffix: String = "") {
        let textFieldText = placeholder ?? ""
        a11y_makeAccessible(label: prefix + textFieldText + suffix, traits: .searchField)
    }
    
    func a11y_setAccessiblePlaceholder(_ placeholder: String) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.accessibilitySpeechPunctuation: true]
        )
    }
}
