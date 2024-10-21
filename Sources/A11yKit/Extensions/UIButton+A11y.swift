//
//  UIButton+A11y.swift
//  A11yKit
//
//  Created by dawncr0w on 10/21/24.
//

import UIKit

public extension UIButton {
    func a11y_optimizeForDynamicType() {
        titleLabel?.adjustsFontForContentSizeCategory = true
        if let customFont = titleLabel?.font {
            titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont)
        }
    }
    
    func a11y_setAccessibleFont(style: UIFont.TextStyle = .body) {
        titleLabel?.font = UIFont.preferredFont(forTextStyle: style)
        titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    func a11y_optimizeContrast() {
        guard let titleColor = titleColor(for: .normal),
              let backgroundColor = backgroundColor ?? superview?.backgroundColor else { return }
        
        let currentContrast = titleColor.contrastRatio(with: backgroundColor)
        if currentContrast < A11yKit.shared.configuration.minimumContrastRatio {
            let adjustedColor = titleColor.adjustedForContrast(against: backgroundColor, targetContrast: A11yKit.shared.configuration.minimumContrastRatio)
            setTitleColor(adjustedColor, for: .normal)
        }
    }
    
    func a11y_makeAccessible(prefix: String = "", suffix: String = "") {
        let buttonText = title(for: .normal) ?? ""
        a11y_makeAccessible(label: prefix + buttonText + suffix, traits: .button)
    }
}
