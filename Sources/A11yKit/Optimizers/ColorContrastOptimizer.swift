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
        
        for subview in view.subviews {
            optimize(subview, with: configuration)
        }
    }
    
    private func optimizeLabel(_ label: UILabel, with configuration: A11yConfiguration) {
        guard let backgroundColor = label.backgroundColor ?? label.superview?.backgroundColor else { return }
        let currentContrast = label.textColor.contrastRatio(with: backgroundColor)
        
        if currentContrast < configuration.minimumContrastRatio {
            label.textColor = label.textColor.adjustedForContrast(against: backgroundColor, targetContrast: configuration.minimumContrastRatio)
        }
    }
    
    private func optimizeButton(_ button: UIButton, with configuration: A11yConfiguration) {
        guard let titleColor = button.titleColor(for: .normal),
              let backgroundColor = button.backgroundColor ?? button.superview?.backgroundColor else { return }
        
        let currentContrast = titleColor.contrastRatio(with: backgroundColor)
        
        if currentContrast < configuration.minimumContrastRatio {
            var adjustedColor = titleColor
            var attempts = 0
            while adjustedColor.contrastRatio(with: backgroundColor) < configuration.minimumContrastRatio && attempts < 10 {
                adjustedColor = adjustedColor.adjustedForContrast(against: backgroundColor, targetContrast: configuration.minimumContrastRatio)
                attempts += 1
            }
            
            button.setTitleColor(adjustedColor, for: .normal)
            
            let newContrast = adjustedColor.contrastRatio(with: backgroundColor)
        }
    }
    
    private func optimizeTextField(_ textField: UITextField, with configuration: A11yConfiguration) {
        guard let textColor = textField.textColor,
              let backgroundColor = textField.backgroundColor ?? textField.superview?.backgroundColor else { return }
        
        let currentContrast = textColor.contrastRatio(with: backgroundColor)
        
        if currentContrast < configuration.minimumContrastRatio {
            textField.textColor = textColor.adjustedForContrast(against: backgroundColor, targetContrast: configuration.minimumContrastRatio)
        }
    }
    
    private func optimizeTextView(_ textView: UITextView, with configuration: A11yConfiguration) {
        guard let textColor = textView.textColor,
              let backgroundColor = textView.backgroundColor ?? textView.superview?.backgroundColor else { return }
        
        let currentContrast = textColor.contrastRatio(with: backgroundColor)
        
        if currentContrast < configuration.minimumContrastRatio {
            textView.textColor = textColor.adjustedForContrast(against: backgroundColor, targetContrast: configuration.minimumContrastRatio)
        }
    }
    
    private func optimizeSegmentedControl(_ segmentedControl: UISegmentedControl, with configuration: A11yConfiguration) {
        guard let backgroundColor = segmentedControl.backgroundColor ?? segmentedControl.superview?.backgroundColor else { return }
        
        for state in [UIControl.State.normal, .selected] {
            if let titleTextAttributes = segmentedControl.titleTextAttributes(for: state),
               let textColor = titleTextAttributes[.foregroundColor] as? UIColor {
                let currentContrast = textColor.contrastRatio(with: backgroundColor)
                
                if currentContrast < configuration.minimumContrastRatio {
                    let adjustedColor = textColor.adjustedForContrast(against: backgroundColor, targetContrast: configuration.minimumContrastRatio)
                    var newAttributes = titleTextAttributes
                    newAttributes[.foregroundColor] = adjustedColor
                    segmentedControl.setTitleTextAttributes(newAttributes, for: state)
                }
            }
        }
    }
    
    private func optimizeSearchBar(_ searchBar: UISearchBar, with configuration: A11yConfiguration) {
        guard let textColor = searchBar.searchTextField.textColor,
              let backgroundColor = searchBar.searchTextField.backgroundColor ?? searchBar.backgroundColor ?? searchBar.superview?.backgroundColor else { return }
        
        let currentContrast = textColor.contrastRatio(with: backgroundColor)
        
        if currentContrast < configuration.minimumContrastRatio {
            searchBar.searchTextField.textColor = textColor.adjustedForContrast(against: backgroundColor, targetContrast: configuration.minimumContrastRatio)
        }
    }
    
    func audit(_ view: UIView, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        switch view {
        case let label as UILabel:
            issues.append(contentsOf: auditLabel(label, with: configuration))
        case let button as UIButton:
            issues.append(contentsOf: auditButton(button, with: configuration))
        case let textField as UITextField:
            issues.append(contentsOf: auditTextField(textField, with: configuration))
        case let textView as UITextView:
            issues.append(contentsOf: auditTextView(textView, with: configuration))
        case let segmentedControl as UISegmentedControl:
            issues.append(contentsOf: auditSegmentedControl(segmentedControl, with: configuration))
        case let searchBar as UISearchBar:
            issues.append(contentsOf: auditSearchBar(searchBar, with: configuration))
        default:
            break
        }
        
        for subview in view.subviews {
            issues.append(contentsOf: audit(subview, with: configuration))
        }
        
        return issues
    }
    
    private func auditLabel(_ label: UILabel, with configuration: A11yConfiguration) -> [A11yIssue] {
        guard let backgroundColor = label.backgroundColor ?? label.superview?.backgroundColor else { return [] }
        let contrast = label.textColor.contrastRatio(with: backgroundColor)
        if contrast < configuration.minimumContrastRatio {
            return [A11yIssue(view: label, issueType: .colorContrast, description: "Insufficient color contrast for label: \(contrast)")]
        }
        return []
    }
    
    private func auditButton(_ button: UIButton, with configuration: A11yConfiguration) -> [A11yIssue] {
        guard let titleColor = button.titleColor(for: .normal),
              let backgroundColor = button.backgroundColor ?? button.superview?.backgroundColor else { return [] }
        
        let contrast = titleColor.contrastRatio(with: backgroundColor)
        if contrast < configuration.minimumContrastRatio {
            let issue = A11yIssue(view: button, issueType: .colorContrast, description: "Insufficient color contrast for button: \(contrast)")
            return [issue]
        }
        return []
    }
    
    private func auditTextField(_ textField: UITextField, with configuration: A11yConfiguration) -> [A11yIssue] {
        guard let textColor = textField.textColor,
              let backgroundColor = textField.backgroundColor ?? textField.superview?.backgroundColor else { return [] }
        let contrast = textColor.contrastRatio(with: backgroundColor)
        if contrast < configuration.minimumContrastRatio {
            return [A11yIssue(view: textField, issueType: .colorContrast, description: "Insufficient color contrast for text field: \(contrast)")]
        }
        return []
    }
    
    private func auditTextView(_ textView: UITextView, with configuration: A11yConfiguration) -> [A11yIssue] {
        guard let textColor = textView.textColor,
              let backgroundColor = textView.backgroundColor ?? textView.superview?.backgroundColor else { return [] }
        let contrast = textColor.contrastRatio(with: backgroundColor)
        if contrast < configuration.minimumContrastRatio {
            return [A11yIssue(view: textView, issueType: .colorContrast, description: "Insufficient color contrast for text view: \(contrast)")]
        }
        return []
    }
    
    private func auditSegmentedControl(_ segmentedControl: UISegmentedControl, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        guard let backgroundColor = segmentedControl.backgroundColor ?? segmentedControl.superview?.backgroundColor else { return [] }
        
        for state in [UIControl.State.normal, .selected] {
            if let titleTextAttributes = segmentedControl.titleTextAttributes(for: state),
               let textColor = titleTextAttributes[.foregroundColor] as? UIColor {
                let contrast = textColor.contrastRatio(with: backgroundColor)
                if contrast < configuration.minimumContrastRatio {
                    issues.append(A11yIssue(view: segmentedControl, issueType: .colorContrast, description: "Insufficient color contrast for segmented control (\(state == .normal ? "normal" : "selected") state): \(contrast)"))
                }
            }
        }
        return issues
    }
    
    private func auditSearchBar(_ searchBar: UISearchBar, with configuration: A11yConfiguration) -> [A11yIssue] {
        guard let textColor = searchBar.searchTextField.textColor,
              let backgroundColor = searchBar.searchTextField.backgroundColor ?? searchBar.backgroundColor ?? searchBar.superview?.backgroundColor else { return [] }
        let contrast = textColor.contrastRatio(with: backgroundColor)
        if contrast < configuration.minimumContrastRatio {
            return [A11yIssue(view: searchBar, issueType: .colorContrast, description: "Insufficient color contrast for search bar: \(contrast)")]
        }
        return []
    }
}
