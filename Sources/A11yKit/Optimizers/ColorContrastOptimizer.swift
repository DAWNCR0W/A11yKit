//
//  ColorContrastOptimizer.swift
//  A11yKit
//
//  Created by dawncr0w on 10/21/24.
//

import UIKit

@MainActor
class ColorContrastOptimizer {
    
    func optimize(_ view: UIView, with configuration: A11yConfiguration) {
        optimizeView(view, with: configuration)
        
        for subview in view.subviews {
            optimize(subview, with: configuration)
        }
    }
    
    private func optimizeView(_ view: UIView, with configuration: A11yConfiguration) {
        switch view {
        case let label as UILabel:
            optimizeLabel(label, with: configuration)
        case let button as UIButton:
            optimizeButton(button, with: configuration)
        case let textField as UITextField:
            optimizeTextField(textField, with: configuration)
        case let textView as UITextView:
            optimizeTextView(textView, with: configuration)
        case let segmentedControl as UISegmentedControl:
            optimizeSegmentedControl(segmentedControl, with: configuration)
        case let searchBar as UISearchBar:
            optimizeSearchBar(searchBar, with: configuration)
        default:
            break
        }
    }
    
    private func optimizeLabel(_ label: UILabel, with configuration: A11yConfiguration) {
        let backgroundColor = getBackgroundColor(label)
        let (adjustedColor, _) = checkAndAdjustContrast(foregroundColor: label.textColor, backgroundColor: backgroundColor, configuration: configuration)
        label.textColor = adjustedColor
    }
    
    private func optimizeButton(_ button: UIButton, with configuration: A11yConfiguration) {
        let backgroundColor = getBackgroundColor(button)
        if let titleColor = button.titleColor(for: .normal) {
            let (adjustedColor, _) = checkAndAdjustContrast(foregroundColor: titleColor, backgroundColor: backgroundColor, configuration: configuration)
            button.setTitleColor(adjustedColor, for: .normal)
        }
    }
    
    private func optimizeTextField(_ textField: UITextField, with configuration: A11yConfiguration) {
        let backgroundColor = getBackgroundColor(textField)
        if let textColor = textField.textColor {
            let (adjustedColor, _) = checkAndAdjustContrast(foregroundColor: textColor, backgroundColor: backgroundColor, configuration: configuration)
            textField.textColor = adjustedColor
        }
    }
    
    private func optimizeTextView(_ textView: UITextView, with configuration: A11yConfiguration) {
        let backgroundColor = getBackgroundColor(textView)
        if let textColor = textView.textColor {
            let (adjustedColor, _) = checkAndAdjustContrast(foregroundColor: textColor, backgroundColor: backgroundColor, configuration: configuration)
            textView.textColor = adjustedColor
        }
    }
    
    private func optimizeSegmentedControl(_ segmentedControl: UISegmentedControl, with configuration: A11yConfiguration) {
        let backgroundColor = getBackgroundColor(segmentedControl)
        for state in [UIControl.State.normal, .selected] {
            if var titleTextAttributes = segmentedControl.titleTextAttributes(for: state),
               let textColor = titleTextAttributes[.foregroundColor] as? UIColor {
                let (adjustedColor, _) = checkAndAdjustContrast(foregroundColor: textColor, backgroundColor: backgroundColor, configuration: configuration)
                titleTextAttributes[.foregroundColor] = adjustedColor
                segmentedControl.setTitleTextAttributes(titleTextAttributes, for: state)
            }
        }
    }
    
    private func optimizeSearchBar(_ searchBar: UISearchBar, with configuration: A11yConfiguration) {
        let backgroundColor = getBackgroundColor(searchBar.searchTextField)
        if let textColor = searchBar.searchTextField.textColor {
            let (adjustedColor, _) = checkAndAdjustContrast(foregroundColor: textColor, backgroundColor: backgroundColor, configuration: configuration)
            searchBar.searchTextField.textColor = adjustedColor
        }
    }
    
    func audit(_ view: UIView, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues = auditView(view, with: configuration)
        
        for subview in view.subviews {
            issues.append(contentsOf: audit(subview, with: configuration))
        }
        
        return issues
    }
    
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
        let (_, contrast) = checkAndAdjustContrast(foregroundColor: label.textColor, backgroundColor: backgroundColor, configuration: configuration)
        if contrast < configuration.minimumContrastRatio {
            return [A11yIssue(view: label, issueType: .colorContrast, description: "Insufficient color contrast for label: \(contrast)")]
        }
        return []
    }
    
    private func auditButton(_ button: UIButton, with configuration: A11yConfiguration) -> [A11yIssue] {
        let backgroundColor = getBackgroundColor(button)
        if let titleColor = button.titleColor(for: .normal) {
            let (_, contrast) = checkAndAdjustContrast(foregroundColor: titleColor, backgroundColor: backgroundColor, configuration: configuration)
            if contrast < configuration.minimumContrastRatio {
                return [A11yIssue(view: button, issueType: .colorContrast, description: "Insufficient color contrast for button: \(contrast)")]
            }
        }
        return []
    }
    
    private func auditTextField(_ textField: UITextField, with configuration: A11yConfiguration) -> [A11yIssue] {
        let backgroundColor = getBackgroundColor(textField)
        if let textColor = textField.textColor {
            let (_, contrast) = checkAndAdjustContrast(foregroundColor: textColor, backgroundColor: backgroundColor, configuration: configuration)
            if contrast < configuration.minimumContrastRatio {
                return [A11yIssue(view: textField, issueType: .colorContrast, description: "Insufficient color contrast for text field: \(contrast)")]
            }
        }
        return []
    }
    
    private func auditTextView(_ textView: UITextView, with configuration: A11yConfiguration) -> [A11yIssue] {
        let backgroundColor = getBackgroundColor(textView)
        if let textColor = textView.textColor {
            let (_, contrast) = checkAndAdjustContrast(foregroundColor: textColor, backgroundColor: backgroundColor, configuration: configuration)
            if contrast < configuration.minimumContrastRatio {
                return [A11yIssue(view: textView, issueType: .colorContrast, description: "Insufficient color contrast for text view: \(contrast)")]
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
                let (_, contrast) = checkAndAdjustContrast(foregroundColor: textColor, backgroundColor: backgroundColor, configuration: configuration)
                if contrast < configuration.minimumContrastRatio {
                    issues.append(A11yIssue(view: segmentedControl, issueType: .colorContrast, description: "Insufficient color contrast for segmented control (\(state == .normal ? "normal" : "selected") state): \(contrast)"))
                }
            }
        }
        return issues
    }
    
    private func auditSearchBar(_ searchBar: UISearchBar, with configuration: A11yConfiguration) -> [A11yIssue] {
        let backgroundColor = getBackgroundColor(searchBar.searchTextField)
        if let textColor = searchBar.searchTextField.textColor {
            let (_, contrast) = checkAndAdjustContrast(foregroundColor: textColor, backgroundColor: backgroundColor, configuration: configuration)
            if contrast < configuration.minimumContrastRatio {
                return [A11yIssue(view: searchBar, issueType: .colorContrast, description: "Insufficient color contrast for search bar: \(contrast)")]
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
        return .white // 기본 배경색
    }
    
    private func checkAndAdjustContrast(foregroundColor: UIColor, backgroundColor: UIColor, configuration: A11yConfiguration) -> (UIColor, CGFloat) {
        let contrast = foregroundColor.contrastRatio(with: backgroundColor)
        if contrast < configuration.minimumContrastRatio {
            let adjustedColor = foregroundColor.adjustedForContrast(against: backgroundColor, targetContrast: configuration.minimumContrastRatio)
            return (adjustedColor, contrast)
        }
        return (foregroundColor, contrast)
    }
}
