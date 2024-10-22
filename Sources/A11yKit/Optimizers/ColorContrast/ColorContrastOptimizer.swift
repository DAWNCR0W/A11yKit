//
//  ColorContrastOptimizer.swift
//  A11yKit
//
//  Created by dawncr0w on 10/21/24.
//

import UIKit

@MainActor
class ColorContrastOptimizer: Optimizer {
    
    // MARK: - Properties
    
    private let minimumContrastRatio: CGFloat
    
    // MARK: - Initialization
    
    init(minimumContrastRatio: CGFloat = 4.5) {
        self.minimumContrastRatio = minimumContrastRatio
    }
    
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
    
    private func checkAndAdjustContrast(foregroundColor: UIColor, backgroundColor: UIColor, configuration: A11yConfiguration) -> (UIColor, CGFloat) {
        let contrast = foregroundColor.contrastRatio(with: backgroundColor)
        if contrast < configuration.minimumContrastRatio {
            let adjustedColor = foregroundColor.adjustedForContrast(against: backgroundColor, targetContrast: configuration.minimumContrastRatio)
            return (adjustedColor, contrast)
        }
        return (foregroundColor, contrast)
    }
}
