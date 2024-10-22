//
//  ColorContrastAuditor.swift
//  A11yKit
//
//  Created by dawncr0w on 10/22/24.
//

import UIKit

@MainActor
class ColorContrastAuditor: @preconcurrency Auditor {
    
    // MARK: - Properties
    
    private let minimumContrastRatio: CGFloat
    
    // MARK: - Initialization
    
    init(minimumContrastRatio: CGFloat = 4.5) {
        self.minimumContrastRatio = minimumContrastRatio
    }
    
    // MARK: - Auditor Protocol
    
    func audit(_ view: UIView, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues = auditView(view, with: configuration)
        
        for subview in view.subviews {
            issues.append(contentsOf: audit(subview, with: configuration))
        }
        
        return issues
    }
    
    // MARK: - Private Methods
    
    private func auditView(_ view: UIView, with configuration: A11yConfiguration) -> [A11yIssue] {
        switch view {
        case let label as UILabel:
            return auditLabel(label, with: configuration)
        case let button as UIButton:
            return auditButton(button, with: configuration)
        case let textField as UITextField:
            return auditTextField(textField, with: configuration)
        case let textView as UITextView:
            return auditTextView(textView, with: configuration)
        case let segmentedControl as UISegmentedControl:
            return auditSegmentedControl(segmentedControl, with: configuration)
        case let searchBar as UISearchBar:
            return auditSearchBar(searchBar, with: configuration)
        default:
            return []
        }
    }
    
    private func auditLabel(_ label: UILabel, with configuration: A11yConfiguration) -> [A11yIssue] {
        let backgroundColor = getBackgroundColor(label)
        let contrast = label.textColor.contrastRatio(with: backgroundColor)
        if contrast < configuration.minimumContrastRatio {
            return [A11yIssue(view: label,
                              issueType: .colorContrast,
                              description: "Insufficient color contrast for label: \(contrast)",
                              severity: .high,
                              suggestion: "Increase the contrast ratio to at least \(configuration.minimumContrastRatio)")]
        }
        return []
    }
    
    private func auditButton(_ button: UIButton, with configuration: A11yConfiguration) -> [A11yIssue] {
        let backgroundColor = getBackgroundColor(button)
        if let titleColor = button.titleColor(for: .normal) {
            let contrast = titleColor.contrastRatio(with: backgroundColor)
            if contrast < configuration.minimumContrastRatio {
                return [A11yIssue(view: button,
                                  issueType: .colorContrast,
                                  description: "Insufficient color contrast for button: \(contrast)",
                                  severity: .high,
                                  suggestion: "Increase the contrast ratio to at least \(configuration.minimumContrastRatio)")]
            }
        }
        return []
    }
    
    private func auditTextField(_ textField: UITextField, with configuration: A11yConfiguration) -> [A11yIssue] {
        let backgroundColor = getBackgroundColor(textField)
        if let textColor = textField.textColor {
            let contrast = textColor.contrastRatio(with: backgroundColor)
            if contrast < configuration.minimumContrastRatio {
                return [A11yIssue(view: textField,
                                  issueType: .colorContrast,
                                  description: "Insufficient color contrast for text field: \(contrast)",
                                  severity: .high,
                                  suggestion: "Increase the contrast ratio to at least \(configuration.minimumContrastRatio)")]
            }
        }
        return []
    }
    
    private func auditTextView(_ textView: UITextView, with configuration: A11yConfiguration) -> [A11yIssue] {
        let backgroundColor = getBackgroundColor(textView)
        if let textColor = textView.textColor {
            let contrast = textColor.contrastRatio(with: backgroundColor)
            if contrast < configuration.minimumContrastRatio {
                return [A11yIssue(view: textView,
                                  issueType: .colorContrast,
                                  description: "Insufficient color contrast for text view: \(contrast)",
                                  severity: .high,
                                  suggestion: "Increase the contrast ratio to at least \(configuration.minimumContrastRatio)")]
            }
        }
        return []
    }
    
    private func auditSegmentedControl(_ segmentedControl: UISegmentedControl, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        let backgroundColor = getBackgroundColor(segmentedControl)
        
        for state in [UIControl.State.normal, .selected] {
            if let titleTextAttributes = segmentedControl.titleTextAttributes(for: state),
               let textColor = titleTextAttributes[.foregroundColor] as? UIColor {
                let contrast = textColor.contrastRatio(with: backgroundColor)
                if contrast < configuration.minimumContrastRatio {
                    issues.append(A11yIssue(view: segmentedControl,
                                            issueType: .colorContrast,
                                            description: "Insufficient color contrast for segmented control (\(state == .normal ? "normal" : "selected") state): \(contrast)",
                                            severity: .high,
                                            suggestion: "Increase the contrast ratio to at least \(configuration.minimumContrastRatio)"))
                }
            }
        }
        return issues
    }
    
    private func auditSearchBar(_ searchBar: UISearchBar, with configuration: A11yConfiguration) -> [A11yIssue] {
        let backgroundColor = getBackgroundColor(searchBar.searchTextField)
        if let textColor = searchBar.searchTextField.textColor {
            let contrast = textColor.contrastRatio(with: backgroundColor)
            if contrast < configuration.minimumContrastRatio {
                return [A11yIssue(view: searchBar,
                                  issueType: .colorContrast,
                                  description: "Insufficient color contrast for search bar: \(contrast)",
                                  severity: .high,
                                  suggestion: "Increase the contrast ratio to at least \(configuration.minimumContrastRatio)")]
            }
        }
        return []
    }
    
    private func getBackgroundColor(_ view: UIView) -> UIColor {
        if let backgroundColor = view.backgroundColor {
            return backgroundColor
        }
        var currentView = view.superview
        while currentView != nil {
            if let backgroundColor = currentView?.backgroundColor {
                return backgroundColor
            }
            currentView = currentView?.superview
        }
        return .white
    }
}
