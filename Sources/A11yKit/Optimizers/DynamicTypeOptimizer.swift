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
        case let tableView as UITableView:
            optimizeTableView(tableView, with: configuration)
        case let collectionView as UICollectionView:
            optimizeCollectionView(collectionView, with: configuration)
        case let searchBar as UISearchBar:
            optimizeSearchBar(searchBar, with: configuration)
        default:
            optimizeGenericView(view, with: configuration)
        }
        
        for subview in view.subviews {
            optimize(subview, with: configuration)
        }
    }
    
    private func optimizeLabel(_ label: UILabel, with configuration: A11yConfiguration) {
        label.adjustsFontForContentSizeCategory = true
        
        if let customFont = label.font {
            if let textStyle = customFont.fontDescriptor.object(forKey: .textStyle) as? UIFont.TextStyle {
                label.font = UIFont.preferredFont(forTextStyle: textStyle)
            } else {
                let newFont = UIFont(descriptor: customFont.fontDescriptor, size: 0)
                label.font = UIFontMetrics.default.scaledFont(for: newFont)
            }
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
            let fontDescriptor = customFont.fontDescriptor
            let textStyle: UIFont.TextStyle = {
                if let textStyle = fontDescriptor.object(forKey: .textStyle) as? UIFont.TextStyle {
                    return textStyle
                } else {
                    return .body
                }
            }()
            
            if let styleDescriptor = fontDescriptor.withDesign(.default)?.withSymbolicTraits(fontDescriptor.symbolicTraits) {
                textField.font = UIFont(descriptor: styleDescriptor, size: UIFont.preferredFont(forTextStyle: textStyle).pointSize)
            } else {
                textField.font = UIFont(descriptor: fontDescriptor, size: UIFont.preferredFont(forTextStyle: textStyle).pointSize)
            }
        } else {
            textField.font = UIFont.preferredFont(forTextStyle: .body)
        }
        
        if configuration.enableLargeContentViewer {
            textField.showsLargeContentViewer = true
        }
    }
    
    private func optimizeTextView(_ textView: UITextView, with configuration: A11yConfiguration) {
        textView.adjustsFontForContentSizeCategory = true
        
        if let customFont = textView.font {
            textView.font = UIFontMetrics.default.scaledFont(for: customFont)
        } else {
            textView.font = UIFont.preferredFont(forTextStyle: .body)
        }
        
        if configuration.enableLargeContentViewer {
            textView.showsLargeContentViewer = true
        }
    }
    
    private func optimizeSegmentedControl(_ segmentedControl: UISegmentedControl, with configuration: A11yConfiguration) {
        let defaultAttributes = segmentedControl.titleTextAttributes(for: .normal) ?? [:]
        let selectedAttributes = segmentedControl.titleTextAttributes(for: .selected) ?? [:]
        
        if let font = defaultAttributes[.font] as? UIFont {
            let scaledFont = UIFontMetrics.default.scaledFont(for: font)
            segmentedControl.setTitleTextAttributes([.font: scaledFont], for: .normal)
        }
        
        if let font = selectedAttributes[.font] as? UIFont {
            let scaledFont = UIFontMetrics.default.scaledFont(for: font)
            segmentedControl.setTitleTextAttributes([.font: scaledFont], for: .selected)
        }
        
        if configuration.enableLargeContentViewer {
            segmentedControl.showsLargeContentViewer = true
        }
    }
    
    private func optimizeTableView(_ tableView: UITableView, with configuration: A11yConfiguration) {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        if configuration.enableLargeContentViewer {
            tableView.showsLargeContentViewer = true
        }
    }
    
    private func optimizeCollectionView(_ collectionView: UICollectionView, with configuration: A11yConfiguration) {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        if configuration.enableLargeContentViewer {
            collectionView.showsLargeContentViewer = true
        }
    }
    
    private func optimizeSearchBar(_ searchBar: UISearchBar, with configuration: A11yConfiguration) {
        searchBar.searchTextField.adjustsFontForContentSizeCategory = true
        
        if let customFont = searchBar.searchTextField.font {
            searchBar.searchTextField.font = UIFontMetrics.default.scaledFont(for: customFont)
        } else {
            searchBar.searchTextField.font = UIFont.preferredFont(forTextStyle: .body)
        }
        
        if configuration.enableLargeContentViewer {
            searchBar.showsLargeContentViewer = true
        }
    }
    
    private func optimizeGenericView(_ view: UIView, with configuration: A11yConfiguration) {
        if configuration.enableLargeContentViewer {
            view.showsLargeContentViewer = true
        }
    }
    
    func audit(_ view: UIView, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        switch view {
        case let label as UILabel:
            if !label.adjustsFontForContentSizeCategory {
                issues.append(A11yIssue(view: label, issueType: .dynamicType, description: "Label not adjusted for Dynamic Type"))
            }
        case let button as UIButton:
            if !(button.titleLabel?.adjustsFontForContentSizeCategory ?? false) {
                issues.append(A11yIssue(view: button, issueType: .dynamicType, description: "Button title not adjusted for Dynamic Type"))
            }
        case let textField as UITextField:
            if !textField.adjustsFontForContentSizeCategory {
                issues.append(A11yIssue(view: textField, issueType: .dynamicType, description: "TextField not adjusted for Dynamic Type"))
            }
        case let textView as UITextView:
            if !textView.adjustsFontForContentSizeCategory {
                issues.append(A11yIssue(view: textView, issueType: .dynamicType, description: "TextView not adjusted for Dynamic Type"))
            }
        case let searchBar as UISearchBar:
            if !searchBar.searchTextField.adjustsFontForContentSizeCategory {
                issues.append(A11yIssue(view: searchBar, issueType: .dynamicType, description: "SearchBar not adjusted for Dynamic Type"))
            }
        default:
            break
        }
        
        if configuration.enableLargeContentViewer && view.showsLargeContentViewer == false {
            issues.append(A11yIssue(view: view, issueType: .dynamicType, description: "Large Content Viewer not enabled"))
        }
        
        for subview in view.subviews {
            issues.append(contentsOf: audit(subview, with: configuration))
        }
        
        return issues
    }
}
