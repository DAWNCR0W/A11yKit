//
//  UIView+A11y.swift
//  A11yKit
//
//  Created by dawncr0w on 10/21/24.
//

import UIKit

public extension UIView {
    func a11y_optimize(options: OptimizationOptions = .all) {
        A11yKit.shared.optimize(self, options: options)
    }
    
    func a11y_makeAccessible(label: String? = nil, hint: String? = nil, traits: UIAccessibilityTraits = []) {
        isAccessibilityElement = true
        if let label = label {
            accessibilityLabel = label
        }
        if let hint = hint {
            accessibilityHint = hint
        }
        if !traits.isEmpty {
            accessibilityTraits = traits
        }
    }
    
    func a11y_hide() {
        isAccessibilityElement = false
        accessibilityElementsHidden = true
    }
    
    func a11y_show() {
        isAccessibilityElement = true
        accessibilityElementsHidden = false
    }
    
    var a11y_isAccessibilityElement: Bool {
        get { return isAccessibilityElement }
        set { isAccessibilityElement = newValue }
    }
    
    func a11y_addCustomAction(_ name: String, action: @escaping () -> Void) {
        let action = UIAccessibilityCustomAction(name: name) { _ in
            action()
            return true
        }
        if accessibilityCustomActions == nil {
            accessibilityCustomActions = [action]
        } else {
            accessibilityCustomActions?.append(action)
        }
    }
}
