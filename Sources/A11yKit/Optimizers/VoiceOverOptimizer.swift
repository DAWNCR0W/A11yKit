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
        switch view {
        case let label as UILabel:
            optimizeLabel(label)
        case let button as UIButton:
            optimizeButton(button)
        case let textField as UITextField:
            optimizeTextField(textField)
        case let imageView as UIImageView:
            optimizeImageView(imageView)
        case let textView as UITextView:
            optimizeTextView(textView)
        case let segmentedControl as UISegmentedControl:
            optimizeSegmentedControl(segmentedControl)
        case let tableView as UITableView:
            optimizeTableView(tableView)
        case let collectionView as UICollectionView:
            optimizeCollectionView(collectionView)
        case let searchBar as UISearchBar:
            optimizeSearchBar(searchBar)
        case let switchControl as UISwitch:
            optimizeSwitch(switchControl)
        case let slider as UISlider:
            optimizeSlider(slider)
        default:
            optimizeGenericView(view)
        }
        
        view.isAccessibilityElement = view.shouldBeAccessibilityElement()
        
        for subview in view.subviews {
            optimize(subview)
        }
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
            textField.accessibilityLabel = textField.placeholder ?? textField.accessibilityIdentifier ?? "Text Field"
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
    
    private func optimizeTextView(_ textView: UITextView) {
        if textView.accessibilityLabel == nil {
            textView.accessibilityLabel = textView.text.isEmpty ? textView.accessibilityIdentifier : textView.text
        }
        textView.accessibilityTraits.insert(.staticText)
    }
    
    private func optimizeSegmentedControl(_ segmentedControl: UISegmentedControl) {
        if segmentedControl.accessibilityLabel == nil {
            segmentedControl.accessibilityLabel = "Segmented Control"
        }
        segmentedControl.accessibilityTraits.insert(.adjustable)
    }
    
    private func optimizeTableView(_ tableView: UITableView) {
        if tableView.accessibilityLabel == nil {
            tableView.accessibilityLabel = "Table"
        }
        tableView.accessibilityTraits.insert(.tabBar)
    }
    
    private func optimizeCollectionView(_ collectionView: UICollectionView) {
        if collectionView.accessibilityLabel == nil {
            collectionView.accessibilityLabel = "Collection"
        }
        collectionView.accessibilityTraits.insert(.tabBar)
    }
    
    private func optimizeSearchBar(_ searchBar: UISearchBar) {
        if searchBar.accessibilityLabel == nil {
            searchBar.accessibilityLabel = searchBar.placeholder ?? "Search"
        }
        searchBar.accessibilityTraits.insert(.searchField)
    }
    
    private func optimizeSwitch(_ switchControl: UISwitch) {
        if switchControl.accessibilityLabel == nil {
            switchControl.accessibilityLabel = switchControl.accessibilityIdentifier ?? "Switch"
        }
        switchControl.accessibilityTraits.insert(.button)
    }
    
    private func optimizeSlider(_ slider: UISlider) {
        if slider.accessibilityLabel == nil {
            slider.accessibilityLabel = slider.accessibilityIdentifier ?? "Slider"
        }
        slider.accessibilityTraits.insert(.adjustable)
    }
    
    private func optimizeGenericView(_ view: UIView) {
        if view.accessibilityLabel == nil {
            view.accessibilityLabel = view.accessibilityIdentifier
        }
    }
    
    func audit(_ view: UIView) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if view.isAccessibilityElement && view.accessibilityLabel == nil {
            issues.append(A11yIssue(view: view, issueType: .voiceOver, description: "Missing accessibility label"))
        }
        
        switch view {
        case let button as UIButton:
            if button.accessibilityLabel == nil && button.titleLabel?.text == nil {
                issues.append(A11yIssue(view: button, issueType: .voiceOver, description: "Button without label or title"))
            }
        case let imageView as UIImageView:
            if imageView.isAccessibilityElement && imageView.accessibilityLabel == nil {
                issues.append(A11yIssue(view: imageView, issueType: .voiceOver, description: "Image without accessibility label"))
            }
        case let textField as UITextField:
            if textField.accessibilityLabel == nil && textField.placeholder == nil {
                issues.append(A11yIssue(view: textField, issueType: .voiceOver, description: "TextField without label or placeholder"))
            }
        case let textView as UITextView:
            if textView.isAccessibilityElement && textView.accessibilityLabel == nil && textView.text.isEmpty {
                issues.append(A11yIssue(view: textView, issueType: .voiceOver, description: "Empty TextView without accessibility label"))
            }
        case let segmentedControl as UISegmentedControl:
            if segmentedControl.accessibilityLabel == nil {
                issues.append(A11yIssue(view: segmentedControl, issueType: .voiceOver, description: "SegmentedControl without accessibility label"))
            }
        default:
            break
        }
        
        for subview in view.subviews {
            issues.append(contentsOf: audit(subview))
        }
        
        return issues
    }
}

private extension UIView {
    func shouldBeAccessibilityElement() -> Bool {
        switch self {
        case is UILabel, is UIButton, is UITextField, is UITextView, is UISwitch, is UISlider:
            return true
        case let imageView as UIImageView:
            return imageView.image != nil
        case is UISegmentedControl, is UITableView, is UICollectionView, is UISearchBar:
            return false
        default:
            return false
        }
    }
}
