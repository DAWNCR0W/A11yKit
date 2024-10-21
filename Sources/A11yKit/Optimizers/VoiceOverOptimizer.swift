//
//  VoiceOverOptimizer.swift
//  A11yKit
//
//  Created by dawncr0w on 10/21/24.
//

import UIKit

@MainActor
class VoiceOverOptimizer {
    
    func optimize(_ view: UIView) {
        if let label = view as? UILabel {
            optimizeLabel(label)
        } else if let button = view as? UIButton {
            optimizeButton(button)
        } else if let textField = view as? UITextField {
            optimizeTextField(textField)
        } else if let imageView = view as? UIImageView {
            optimizeImageView(imageView)
        }
        
        // Set isAccessibilityElement based on content
        view.isAccessibilityElement = view.shouldBeAccessibilityElement()
    }
    
    private func optimizeLabel(_ label: UILabel) {
        if label.accessibilityLabel == nil {
            label.accessibilityLabel = label.text
        }
        label.accessibilityTraits.insert(.staticText)
    }
    
    private func optimizeButton(_ button: UIButton) {
        if button.accessibilityLabel == nil {
            button.accessibilityLabel = button.titleLabel?.text ?? button.accessibilityIdentifier
        }
        button.accessibilityTraits.insert(.button)
    }
    
    private func optimizeTextField(_ textField: UITextField) {
        if textField.accessibilityLabel == nil {
            textField.accessibilityLabel = textField.placeholder ?? textField.accessibilityIdentifier
        }
        textField.accessibilityTraits.insert(.searchField)
    }
    
    private func optimizeImageView(_ imageView: UIImageView) {
        if imageView.accessibilityLabel == nil {
            imageView.accessibilityLabel = imageView.accessibilityIdentifier ?? "Image"
        }
        imageView.accessibilityTraits.insert(.image)
        
        if imageView.isUserInteractionEnabled {
            imageView.accessibilityTraits.insert(.button)
        }
    }
    
    func audit(_ view: UIView) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if view.isAccessibilityElement && view.accessibilityLabel == nil {
            issues.append(A11yIssue(view: view, issueType: .voiceOver, description: "Missing accessibility label"))
        }
        
        if let button = view as? UIButton, button.accessibilityLabel == nil && button.titleLabel?.text == nil {
            issues.append(A11yIssue(view: button, issueType: .voiceOver, description: "Button without label or title"))
        }
        
        if let imageView = view as? UIImageView, imageView.isAccessibilityElement && imageView.accessibilityLabel == nil {
            issues.append(A11yIssue(view: imageView, issueType: .voiceOver, description: "Image without accessibility label"))
        }
        
        return issues
    }
}

private extension UIView {
    func shouldBeAccessibilityElement() -> Bool {
        if self is UILabel || self is UIButton || self is UITextField {
            return true
        }
        if let imageView = self as? UIImageView, imageView.image != nil {
            return true
        }
        return false
    }
}
