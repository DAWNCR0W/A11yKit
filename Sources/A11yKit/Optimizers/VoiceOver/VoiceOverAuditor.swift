//
//  VoiceOverAuditor.swift
//  A11yKit
//
//  Created by 서동혁 on 10/22/24.
//

import UIKit

@MainActor
class VoiceOverAuditor: Auditor {
    
    // MARK: - Auditor Protocol
    
    func audit(_ view: UIView, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        issues.append(contentsOf: auditView(view, with: configuration))
        
        for subview in view.subviews {
            issues.append(contentsOf: audit(subview, with: configuration))
        }
        
        return issues
    }
    
    // MARK: - Private Methods
    
    private func auditView(_ view: UIView, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if view.isAccessibilityElement && view.accessibilityLabel == nil {
            issues.append(A11yIssue(view: view,
                                    issueType: .voiceOver,
                                    description: "Missing accessibility label",
                                    severity: .high,
                                    suggestion: "Add an accessibility label to this view"))
        }
        
        switch view {
        case let label as UILabel:
            issues.append(contentsOf: auditLabel(label, with: configuration))
        case let button as UIButton:
            issues.append(contentsOf: auditButton(button, with: configuration))
        case let textField as UITextField:
            issues.append(contentsOf: auditTextField(textField, with: configuration))
        case let imageView as UIImageView:
            issues.append(contentsOf: auditImageView(imageView, with: configuration))
        case let textView as UITextView:
            issues.append(contentsOf: auditTextView(textView, with: configuration))
        case let segmentedControl as UISegmentedControl:
            issues.append(contentsOf: auditSegmentedControl(segmentedControl, with: configuration))
        case let tableView as UITableView:
            issues.append(contentsOf: auditTableView(tableView, with: configuration))
        case let collectionView as UICollectionView:
            issues.append(contentsOf: auditCollectionView(collectionView, with: configuration))
        case let searchBar as UISearchBar:
            issues.append(contentsOf: auditSearchBar(searchBar, with: configuration))
        case let switchControl as UISwitch:
            issues.append(contentsOf: auditSwitch(switchControl, with: configuration))
        case let slider as UISlider:
            issues.append(contentsOf: auditSlider(slider, with: configuration))
        default:
            break
        }
        
        return issues
    }
    
    private func auditLabel(_ label: UILabel, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if label.text?.isEmpty ?? true && label.accessibilityLabel == nil {
            issues.append(A11yIssue(view: label,
                                    issueType: .voiceOver,
                                    description: "Empty label without accessibility label",
                                    severity: .high,
                                    suggestion: "Add an accessibility label or text to this label"))
        }
        
        return issues
    }
    
    private func auditButton(_ button: UIButton, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if button.accessibilityLabel == nil && button.titleLabel?.text == nil {
            issues.append(A11yIssue(view: button,
                                    issueType: .voiceOver,
                                    description: "Button without label or title",
                                    severity: .high,
                                    suggestion: "Add an accessibility label or title to this button"))
        }
        
        return issues
    }
    
    private func auditTextField(_ textField: UITextField, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if textField.accessibilityLabel == nil && textField.placeholder == nil {
            issues.append(A11yIssue(view: textField,
                                    issueType: .voiceOver,
                                    description: "TextField without label or placeholder",
                                    severity: .high,
                                    suggestion: "Add an accessibility label or placeholder to this text field"))
        }
        
        return issues
    }
    
    private func auditImageView(_ imageView: UIImageView, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if imageView.isAccessibilityElement && imageView.accessibilityLabel == nil {
            issues.append(A11yIssue(view: imageView,
                                    issueType: .voiceOver,
                                    description: "Image without accessibility label",
                                    severity: .high,
                                    suggestion: "Add an accessibility label to this image"))
        }
        
        return issues
    }
    
    private func auditTextView(_ textView: UITextView, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if textView.isAccessibilityElement && textView.accessibilityLabel == nil && textView.text.isEmpty {
            issues.append(A11yIssue(view: textView,
                                    issueType: .voiceOver,
                                    description: "Empty TextView without accessibility label",
                                    severity: .high,
                                    suggestion: "Add an accessibility label to this empty text view"))
        }
        
        return issues
    }
    
    private func auditSegmentedControl(_ segmentedControl: UISegmentedControl, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if segmentedControl.accessibilityLabel == nil {
            issues.append(A11yIssue(view: segmentedControl,
                                    issueType: .voiceOver,
                                    description: "SegmentedControl without accessibility label",
                                    severity: .medium,
                                    suggestion: "Add an accessibility label to this segmented control"))
        }
        
        return issues
    }
    
    private func auditTableView(_ tableView: UITableView, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if tableView.accessibilityLabel == nil {
            issues.append(A11yIssue(view: tableView,
                                    issueType: .voiceOver,
                                    description: "TableView without accessibility label",
                                    severity: .low,
                                    suggestion: "Consider adding an accessibility label to this table view"))
        }
        
        return issues
    }
    
    private func auditCollectionView(_ collectionView: UICollectionView, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if collectionView.accessibilityLabel == nil {
            issues.append(A11yIssue(view: collectionView,
                                    issueType: .voiceOver,
                                    description: "CollectionView without accessibility label",
                                    severity: .low,
                                    suggestion: "Consider adding an accessibility label to this collection view"))
        }
        
        return issues
    }
    
    private func auditSearchBar(_ searchBar: UISearchBar, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if searchBar.accessibilityLabel == nil && searchBar.placeholder == nil {
            issues.append(A11yIssue(view: searchBar,
                                    issueType: .voiceOver,
                                    description: "SearchBar without accessibility label or placeholder",
                                    severity: .medium,
                                    suggestion: "Add an accessibility label or placeholder to this search bar"))
        }
        
        return issues
    }
    
    private func auditSwitch(_ switchControl: UISwitch, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if switchControl.accessibilityLabel == nil {
            issues.append(A11yIssue(view: switchControl,
                                    issueType: .voiceOver,
                                    description: "Switch without accessibility label",
                                    severity: .high,
                                    suggestion: "Add an accessibility label to this switch"))
        }
        
        return issues
    }
    
    private func auditSlider(_ slider: UISlider, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if slider.accessibilityLabel == nil {
            issues.append(A11yIssue(view: slider,
                                    issueType: .voiceOver,
                                    description: "Slider without accessibility label",
                                    severity: .high,
                                    suggestion: "Add an accessibility label to this slider"))
        }
        
        return issues
    }
}
