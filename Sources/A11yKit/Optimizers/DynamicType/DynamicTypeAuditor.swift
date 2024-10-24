//
//  DynamicTypeAuditor.swift
//  A11yKit
//
//  Created by dawncr0w on 10/22/24.
//

import UIKit

@MainActor
class DynamicTypeAuditor: @preconcurrency Auditor {
    
    // MARK: - Auditor Protocol
    
    func audit(_ view: UIView, with configuration: A11yConfiguration) -> [A11yIssue] {
        guard configuration.enableDynamicType else { return [] }
        guard view.shouldPerformAccessibilityOptimization(with: configuration) else { return [] }
        
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
        case let tableView as UITableView:
            issues.append(contentsOf: auditTableView(tableView, with: configuration))
        case let collectionView as UICollectionView:
            issues.append(contentsOf: auditCollectionView(collectionView, with: configuration))
        case let searchBar as UISearchBar:
            issues.append(contentsOf: auditSearchBar(searchBar, with: configuration))
        default:
            break
        }
        
        if configuration.enableLargeContentViewer && !view.showsLargeContentViewer {
            issues.append(A11yIssue(view: view,
                                    issueType: .dynamicType,
                                    description: "Large Content Viewer not enabled",
                                    severity: .medium,
                                    suggestion: "Enable Large Content Viewer for this view"))
        }
        
        let currentCategory = UIApplication.shared.preferredContentSizeCategory
        if !configuration.isContentSizeCategoryAllowed(currentCategory) {
            issues.append(A11yIssue(view: view,
                                    issueType: .dynamicType,
                                    description: "Current content size category (\(currentCategory)) is outside the allowed range",
                                    severity: .high,
                                    suggestion: "Adjust the content size category range in the configuration"))
        }
        
        return issues
    }
    
    private func auditLabel(_ label: UILabel, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if !label.adjustsFontForContentSizeCategory {
            issues.append(A11yIssue(view: label,
                                    issueType: .dynamicType,
                                    description: "Label not adjusted for Dynamic Type",
                                    severity: .high,
                                    suggestion: "Enable adjustsFontForContentSizeCategory"))
        }
        
        if let font = label.font {
            let metrics = UIFontMetrics(forTextStyle: .body)
            let scaledFont = metrics.scaledFont(for: font)
            
            if scaledFont == font {
                issues.append(A11yIssue(view: label,
                                        issueType: .dynamicType,
                                        description: "Label font is not scaling with Dynamic Type",
                                        severity: .medium,
                                        suggestion: "Use a scalable font with UIFontMetrics"))
            }
        }
        
        return issues
    }
    
    private func auditButton(_ button: UIButton, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if !(button.titleLabel?.adjustsFontForContentSizeCategory ?? false) {
            issues.append(A11yIssue(view: button,
                                    issueType: .dynamicType,
                                    description: "Button title not adjusted for Dynamic Type",
                                    severity: .high,
                                    suggestion: "Enable adjustsFontForContentSizeCategory for the button's titleLabel"))
        }
        
        if let titleFont = button.titleLabel?.font,
           !titleFont.fontDescriptor.symbolicTraits.contains(.traitUIOptimized) {
            issues.append(A11yIssue(view: button,
                                    issueType: .dynamicType,
                                    description: "Button title font is not scaling with Dynamic Type",
                                    severity: .medium,
                                    suggestion: "Use a scalable font or UIFontMetrics"))
        }
        
        return issues
    }
    
    private func auditTextField(_ textField: UITextField, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if !textField.adjustsFontForContentSizeCategory {
            issues.append(A11yIssue(view: textField,
                                    issueType: .dynamicType,
                                    description: "TextField not adjusted for Dynamic Type",
                                    severity: .high,
                                    suggestion: "Enable adjustsFontForContentSizeCategory"))
        }
        
        if let font = textField.font, !font.fontDescriptor.symbolicTraits.contains(.traitUIOptimized) {
            issues.append(A11yIssue(view: textField,
                                    issueType: .dynamicType,
                                    description: "TextField font is not scaling with Dynamic Type",
                                    severity: .medium,
                                    suggestion: "Use a scalable font or UIFontMetrics"))
        }
        
        return issues
    }
    
    private func auditTextView(_ textView: UITextView, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if !textView.adjustsFontForContentSizeCategory {
            issues.append(A11yIssue(view: textView,
                                    issueType: .dynamicType,
                                    description: "TextView not adjusted for Dynamic Type",
                                    severity: .high,
                                    suggestion: "Enable adjustsFontForContentSizeCategory"))
        }
        
        if let font = textView.font, !font.fontDescriptor.symbolicTraits.contains(.traitUIOptimized) {
            issues.append(A11yIssue(view: textView,
                                    issueType: .dynamicType,
                                    description: "TextView font is not scaling with Dynamic Type",
                                    severity: .medium,
                                    suggestion: "Use a scalable font or UIFontMetrics"))
        }
        
        return issues
    }
    
    private func auditSegmentedControl(_ segmentedControl: UISegmentedControl, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        // Segmented controls don't have a direct property for adjustsFontForContentSizeCategory
        // Instead, we check if the font is a dynamic type font
        if let attributes = segmentedControl.titleTextAttributes(for: .normal),
           let font = attributes[.font] as? UIFont,
           !font.fontDescriptor.symbolicTraits.contains(.traitUIOptimized) {
            issues.append(A11yIssue(view: segmentedControl,
                                    issueType: .dynamicType,
                                    description: "SegmentedControl not using Dynamic Type fonts",
                                    severity: .medium,
                                    suggestion: "Use scaled fonts for segmented control titles"))
        }
        
        return issues
    }
    
    private func auditTableView(_ tableView: UITableView, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if tableView.rowHeight != UITableView.automaticDimension {
            issues.append(A11yIssue(view: tableView,
                                    issueType: .dynamicType,
                                    description: "TableView not using automatic dimensions",
                                    severity: .medium,
                                    suggestion: "Set rowHeight to UITableView.automaticDimension"))
        }
        
        return issues
    }
    
    private func auditCollectionView(_ collectionView: UICollectionView, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout,
           layout.estimatedItemSize != UICollectionViewFlowLayout.automaticSize {
            issues.append(A11yIssue(view: collectionView,
                                    issueType: .dynamicType,
                                    description: "CollectionView not using automatic dimensions",
                                    severity: .medium,
                                    suggestion: "Set estimatedItemSize to UICollectionViewFlowLayout.automaticSize"))
        }
        
        return issues
    }
    
    private func auditSearchBar(_ searchBar: UISearchBar, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if !searchBar.searchTextField.adjustsFontForContentSizeCategory {
            issues.append(A11yIssue(view: searchBar,
                                    issueType: .dynamicType,
                                    description: "SearchBar text field not adjusted for Dynamic Type",
                                    severity: .high,
                                    suggestion: "Enable adjustsFontForContentSizeCategory for the search text field"))
        }
        
        if let font = searchBar.searchTextField.font, !font.fontDescriptor.symbolicTraits.contains(.traitUIOptimized) {
            issues.append(A11yIssue(view: searchBar,
                                    issueType: .dynamicType,
                                    description: "SearchBar text field font is not scaling with Dynamic Type",
                                    severity: .medium,
                                    suggestion: "Use a scalable font or UIFontMetrics"))
        }
        
        return issues
    }
}
