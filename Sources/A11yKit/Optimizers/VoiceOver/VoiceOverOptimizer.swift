//
//  VoiceOverOptimizer.swift
//  A11yKit
//
//  Created by dawncr0w on 10/21/24.
//

import UIKit

@MainActor
class VoiceOverOptimizer: @preconcurrency Optimizer {
    
    // MARK: - Optimizer Protocol
    
    func optimize(_ view: UIView, with configuration: A11yConfiguration) {
        guard configuration.enableVoiceOverOptimization else { return }
        guard view.shouldPerformAccessibilityOptimization(with: configuration) else { return }
        
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
        
        if configuration.autoGenerateVoiceOverLabels && view.accessibilityLabel == nil {
            view.accessibilityLabel = generateAccessibilityLabel(for: view, with: configuration)
        }
    }
    
    private func optimizeLabel(_ label: UILabel, with configuration: A11yConfiguration) {
        if label.accessibilityLabel == nil {
            if configuration.autoGenerateVoiceOverLabels {
                label.accessibilityLabel = generateAccessibilityLabel(for: label, with: configuration)
            } else {
                label.accessibilityLabel = label.text
            }
        }
        label.accessibilityTraits.insert(.staticText)
    }
    
    private func optimizeButton(_ button: UIButton, with configuration: A11yConfiguration) {
        if button.accessibilityLabel == nil {
            if configuration.autoGenerateVoiceOverLabels {
                button.accessibilityLabel = generateAccessibilityLabel(for: button, with: configuration)
            } else {
                button.accessibilityLabel = button.titleLabel?.text
            }
        }
        button.accessibilityTraits.insert(.button)
    }
    
    private func optimizeTextField(_ textField: UITextField, with configuration: A11yConfiguration) {
        if textField.accessibilityLabel == nil {
            if configuration.autoGenerateVoiceOverLabels {
                textField.accessibilityLabel = generateAccessibilityLabel(for: textField, with: configuration)
            } else {
                textField.accessibilityLabel = textField.placeholder
            }
        }
        textField.accessibilityTraits.insert(.searchField)
    }
    
    private func optimizeImageView(_ imageView: UIImageView, with configuration: A11yConfiguration) {
        if imageView.accessibilityLabel == nil {
            if configuration.autoGenerateVoiceOverLabels {
                imageView.accessibilityLabel = generateAccessibilityLabel(for: imageView, with: configuration)
            } else {
                imageView.accessibilityLabel = imageView.accessibilityIdentifier
            }
        }
        imageView.accessibilityTraits.insert(.image)
        
        if imageView.isUserInteractionEnabled {
            imageView.accessibilityTraits.insert(.button)
        }
    }
    
    private func optimizeTextView(_ textView: UITextView, with configuration: A11yConfiguration) {
        if textView.accessibilityLabel == nil {
            if configuration.autoGenerateVoiceOverLabels {
                textView.accessibilityLabel = generateAccessibilityLabel(for: textView, with: configuration)
            } else {
                textView.accessibilityLabel = textView.accessibilityIdentifier
            }
        }
        textView.accessibilityTraits.insert(.staticText)
    }
    
    private func optimizeSegmentedControl(_ segmentedControl: UISegmentedControl, with configuration: A11yConfiguration) {
        if segmentedControl.accessibilityLabel == nil {
            if configuration.autoGenerateVoiceOverLabels {
                segmentedControl.accessibilityLabel = generateAccessibilityLabel(for: segmentedControl, with: configuration)
            } else {
                segmentedControl.accessibilityLabel = segmentedControl.accessibilityIdentifier
            }
        }
        segmentedControl.accessibilityTraits.insert(.adjustable)
        
        for i in 0..<segmentedControl.numberOfSegments {
            if let title = segmentedControl.titleForSegment(at: i) {
                segmentedControl.setTitle(configuration.voiceOverLabelPrefix + title + configuration.voiceOverLabelSuffix, forSegmentAt: i)
            }
        }
    }
    
    private func optimizeTableView(_ tableView: UITableView, with configuration: A11yConfiguration) {
        if tableView.accessibilityLabel == nil {
            if configuration.autoGenerateVoiceOverLabels {
                tableView.accessibilityLabel = generateAccessibilityLabel(for: tableView, with: configuration)
            } else {
                tableView.accessibilityLabel = tableView.accessibilityIdentifier
            }
        }
        tableView.accessibilityTraits.insert(.tabBar)
    }
    
    private func optimizeCollectionView(_ collectionView: UICollectionView, with configuration: A11yConfiguration) {
        if collectionView.accessibilityLabel == nil {
            if configuration.autoGenerateVoiceOverLabels {
                collectionView.accessibilityLabel = generateAccessibilityLabel(for: collectionView, with: configuration)
            } else {
                collectionView.accessibilityLabel = collectionView.accessibilityIdentifier
            }
        }
        collectionView.accessibilityTraits.insert(.tabBar)
    }
    
    private func optimizeSearchBar(_ searchBar: UISearchBar, with configuration: A11yConfiguration) {
        if searchBar.accessibilityLabel == nil {
            if configuration.autoGenerateVoiceOverLabels {
                searchBar.accessibilityLabel = generateAccessibilityLabel(for: searchBar, with: configuration)
            } else {
                searchBar.accessibilityLabel = searchBar.accessibilityIdentifier
            }
        }
        searchBar.accessibilityTraits.insert(.searchField)
    }
    
    private func optimizeSwitch(_ switchControl: UISwitch, with configuration: A11yConfiguration) {
        if switchControl.accessibilityLabel == nil {
            if configuration.autoGenerateVoiceOverLabels {
                switchControl.accessibilityLabel = generateAccessibilityLabel(for: switchControl, with: configuration)
            } else {
                switchControl.accessibilityLabel = switchControl.accessibilityIdentifier
            }
        }
        switchControl.accessibilityTraits.insert(.button)
    }
    
    private func optimizeSlider(_ slider: UISlider, with configuration: A11yConfiguration) {
        if slider.accessibilityLabel == nil {
            if configuration.autoGenerateVoiceOverLabels {
                slider.accessibilityLabel = generateAccessibilityLabel(for: slider, with: configuration)
            } else {
                slider.accessibilityLabel = slider.accessibilityIdentifier
            }
        }
        slider.accessibilityTraits.insert(.adjustable)
    }
    
    private func optimizeGenericView(_ view: UIView, with configuration: A11yConfiguration) {
        if view.accessibilityLabel == nil {
            if configuration.autoGenerateVoiceOverLabels {
                view.accessibilityLabel = generateAccessibilityLabel(for: view, with: configuration)
            } else {
                view.accessibilityLabel = view.accessibilityIdentifier
            }
        }
    }
    
    private func generateAccessibilityLabel(for view: UIView, with configuration: A11yConfiguration) -> String {
        let baseLabel: String
        
        switch view {
        case let label as UILabel:
            baseLabel = label.text ?? "Label"
        case let button as UIButton:
            baseLabel = button.titleLabel?.text ?? "Button"
        case let textField as UITextField:
            baseLabel = textField.placeholder ?? "Text Field"
        case let imageView as UIImageView:
            baseLabel = imageView.accessibilityIdentifier ?? "Image"
        case let textView as UITextView:
            baseLabel = textView.accessibilityIdentifier ?? "Text View"
        case let segmentedControl as UISegmentedControl:
            baseLabel = segmentedControl.accessibilityIdentifier ?? "Segmented Control"
        case let tableView as UITableView:
            baseLabel = tableView.accessibilityIdentifier ?? "Table View"
        case let collectionView as UICollectionView:
            baseLabel = collectionView.accessibilityIdentifier ?? "Collection View"
        case let searchBar as UISearchBar:
            baseLabel = searchBar.accessibilityIdentifier ?? "Search Bar"
        default:
            baseLabel = view.accessibilityIdentifier ?? "View"
        }
        
        return "\(configuration.voiceOverLabelPrefix)\(baseLabel)\(configuration.voiceOverLabelSuffix)"
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
