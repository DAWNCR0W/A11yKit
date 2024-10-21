//
//  DynamicTypeOptimizer.swift
//  A11yKit
//
//  Created by dawncr0w on 10/21/24.
//

import UIKit

@MainActor
class DynamicTypeOptimizer {
    
    func optimize(_ view: UIView, with configuration: A11yConfiguration) {
        if let label = view as? UILabel {
            optimizeLabel(label, with: configuration)
        } else if let button = view as? UIButton {
            optimizeButton(button, with: configuration)
        } else if let textField = view as? UITextField {
            optimizeTextField(textField, with: configuration)
        }
    }
    
    private func optimizeLabel(_ label: UILabel, with configuration: A11yConfiguration) {
        label.adjustsFontForContentSizeCategory = true
        if let customFont = label.font {
            label.font = UIFontMetrics.default.scaledFont(for: customFont)
        } else {
            label.font = UIFont.preferredFont(forTextStyle: .body)
        }
        
        if configuration.enableLargeContentViewer {
            label.showsLargeContentViewer = true
        }
    }
    
    private func optimizeButton(_ button: UIButton, with configuration: A11yConfiguration) {
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        if let customFont = button.titleLabel?.font {
            button.titleLabel?.font = UIFontMetrics.default.scaledFont(for: customFont)
        } else {
            button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        }
        
        if configuration.enableLargeContentViewer {
            button.showsLargeContentViewer = true
        }
    }
    
    private func optimizeTextField(_ textField: UITextField, with configuration: A11yConfiguration) {
        textField.adjustsFontForContentSizeCategory = true
        if let customFont = textField.font {
            textField.font = UIFontMetrics.default.scaledFont(for: customFont)
        } else {
            textField.font = UIFont.preferredFont(forTextStyle: .body)
        }
        
        if configuration.enableLargeContentViewer {
            textField.showsLargeContentViewer = true
        }
    }
    
    func audit(_ view: UIView, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if let label = view as? UILabel, !label.adjustsFontForContentSizeCategory {
            issues.append(A11yIssue(view: label, issueType: .dynamicType, description: "Label not adjusted for Dynamic Type"))
        }
        
        if let button = view as? UIButton, !(button.titleLabel?.adjustsFontForContentSizeCategory ?? false) {
            issues.append(A11yIssue(view: button, issueType: .dynamicType, description: "Button title not adjusted for Dynamic Type"))
        }
        
        if let textField = view as? UITextField, !textField.adjustsFontForContentSizeCategory {
            issues.append(A11yIssue(view: textField, issueType: .dynamicType, description: "TextField not adjusted for Dynamic Type"))
        }
        
        if configuration.enableLargeContentViewer && view.showsLargeContentViewer == false {
            issues.append(A11yIssue(view: view, issueType: .dynamicType, description: "Large Content Viewer not enabled"))
        }
        
        return issues
    }
}
