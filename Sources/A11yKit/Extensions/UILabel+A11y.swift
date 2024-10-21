//
//  UILabel+A11y.swift
//  A11yKit
//
//  Created by dawncr0w on 10/21/24.
//

import UIKit

public extension UILabel {
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
    
    func a11y_optimizeContrast(against backgroundColor: UIColor) {
        guard let currentTextColor = textColor else { return }
        let minimumContrastRatio = A11yKit.shared.configuration.minimumContrastRatio ?? 4.5 // WCAG AA
        let currentContrast = currentTextColor.contrastRatio(with: backgroundColor)
        if currentContrast < minimumContrastRatio {
            textColor = currentTextColor.adjustedForContrast(against: backgroundColor, targetContrast: minimumContrastRatio)
        }
    }
    
    func a11y_makeAccessible(prefix: String = "", suffix: String = "", fallbackText: String = "Label") {
        let labelText = text ?? fallbackText
        a11y_makeAccessible(label: prefix + labelText + suffix)
    }
}
