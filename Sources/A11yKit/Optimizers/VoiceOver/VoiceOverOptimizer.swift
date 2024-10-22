//
//  VoiceOverOptimizer.swift
//  A11yKit
//
//  Created by dawncr0w on 10/21/24.
//

import UIKit

@MainActor
class VoiceOverOptimizer: Optimizer {
    
    // MARK: - Optimizer Protocol
    
    func optimize(_ view: UIView, with configuration: A11yConfiguration) {
        optimizeView(view, with: configuration)
        
        for subview in view.subviews {
            optimize(subview, with: configuration)
        }
    }
    
    // MARK: - Private Methods
    
    private func optimizeView(_ view: UIView, with configuration: A11yConfiguration) {
        switch view {
        case let label as UILabel:
            optimizeLabel(label, with: configuration)
        case let button as UIButton:
            optimizeButton(button, with: configuration)
        case let textField as UITextField:
            optimizeTextField(textField, with: configuration)
        case let imageView as UIImageView:
            optimizeImageView(imageView, with: configuration)
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
        case let switchControl as UISwitch:
            optimizeSwitch(switchControl, with: configuration)
        case let slider as UISlider:
            optimizeSlider(slider, with: configuration)
        default:
            optimizeGenericView(view, with: configuration)
        }
        
        view.isAccessibilityElement = view.shouldBeAccessibilityElement()
    }
    
    private func optimizeLabel(_ label: UILabel, with configuration: A11yConfiguration) {
        if label.accessibilityLabel == nil {
            label.accessibilityLabel = label.text
        }
        label.accessibilityTraits.insert(.staticText)
    }
    
    private func optimizeButton(_ button: UIButton, with configuration: A11yConfiguration) {
        if button.accessibilityLabel == nil {
            button.accessibilityLabel = button.titleLabel?.text ?? button.accessibilityIdentifier
        }
        button.accessibilityTraits.insert(.button)
    }
    
    private func optimizeTextField(_ textField: UITextField, with configuration: A11yConfiguration) {
        if textField.accessibilityLabel == nil {
            textField.accessibilityLabel = textField.placeholder ?? textField.accessibilityIdentifier ?? "Text Field"
        }
        textField.accessibilityTraits.insert(.searchField)
    }
    
    private func optimizeImageView(_ imageView: UIImageView, with configuration: A11yConfiguration) {
        if imageView.accessibilityLabel == nil {
            imageView.accessibilityLabel = imageView.accessibilityIdentifier ?? "Image"
        }
        imageView.accessibilityTraits.insert(.image)
        
        if imageView.isUserInteractionEnabled {
            imageView.accessibilityTraits.insert(.button)
        }
    }
    
    private func optimizeTextView(_ textView: UITextView, with configuration: A11yConfiguration) {
        if textView.accessibilityLabel == nil {
            textView.accessibilityLabel = textView.text.isEmpty ? textView.accessibilityIdentifier : textView.text
        }
        textView.accessibilityTraits.insert(.staticText)
    }
    
    private func optimizeSegmentedControl(_ segmentedControl: UISegmentedControl, with configuration: A11yConfiguration) {
        if segmentedControl.accessibilityLabel == nil {
            segmentedControl.accessibilityLabel = "Segmented Control"
        }
        segmentedControl.accessibilityTraits.insert(.adjustable)
    }
    
    private func optimizeTableView(_ tableView: UITableView, with configuration: A11yConfiguration) {
        if tableView.accessibilityLabel == nil {
            tableView.accessibilityLabel = "Table"
        }
        tableView.accessibilityTraits.insert(.tabBar)
    }
    
    private func optimizeCollectionView(_ collectionView: UICollectionView, with configuration: A11yConfiguration) {
        if collectionView.accessibilityLabel == nil {
            collectionView.accessibilityLabel = "Collection"
        }
        collectionView.accessibilityTraits.insert(.tabBar)
    }
    
    private func optimizeSearchBar(_ searchBar: UISearchBar, with configuration: A11yConfiguration) {
        if searchBar.accessibilityLabel == nil {
            searchBar.accessibilityLabel = searchBar.placeholder ?? "Search"
        }
        searchBar.accessibilityTraits.insert(.searchField)
    }
    
    private func optimizeSwitch(_ switchControl: UISwitch, with configuration: A11yConfiguration) {
        if switchControl.accessibilityLabel == nil {
            switchControl.accessibilityLabel = switchControl.accessibilityIdentifier ?? "Switch"
        }
        switchControl.accessibilityTraits.insert(.button)
    }
    
    private func optimizeSlider(_ slider: UISlider, with configuration: A11yConfiguration) {
        if slider.accessibilityLabel == nil {
            slider.accessibilityLabel = slider.accessibilityIdentifier ?? "Slider"
        }
        slider.accessibilityTraits.insert(.adjustable)
    }
    
    private func optimizeGenericView(_ view: UIView, with configuration: A11yConfiguration) {
        if view.accessibilityLabel == nil {
            view.accessibilityLabel = view.accessibilityIdentifier
        }
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
