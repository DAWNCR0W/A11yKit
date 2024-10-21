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
        }
    }
    
    func a11y_setAccessibleFont(style: UIFont.TextStyle = .body) {
        font = UIFont.preferredFont(forTextStyle: style)
        adjustsFontForContentSizeCategory = true
    }
    
    func a11y_optimizeContrast(against backgroundColor: UIColor) {
        let currentContrast = textColor.contrastRatio(with: backgroundColor)
        if currentContrast < A11yKit.shared.configuration.minimumContrastRatio {
            textColor = textColor.adjustedForContrast(against: backgroundColor, targetContrast: A11yKit.shared.configuration.minimumContrastRatio)
        }
    }
    
    func a11y_makeAccessible(prefix: String = "", suffix: String = "") {
        a11y_makeAccessible(label: prefix + (text ?? "") + suffix)
    }
}
