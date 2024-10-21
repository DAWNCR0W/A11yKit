//
//  ColorContrastOptimizer.swift
//  A11yKit
//
//  Created by dawncr0w on 10/21/24.
//

import UIKit

class ColorContrastOptimizer {
    
    func optimize(_ view: UIView, with configuration: A11yConfiguration) {
        if let label = view as? UILabel {
            optimizeLabel(label, with: configuration)
        } else if let button = view as? UIButton {
            optimizeButton(button, with: configuration)
        } else if let textField = view as? UITextField {
            optimizeTextField(textField, with: configuration)
        }
    }
    
    private func optimizeLabel(_ label: UILabel, with configuration: A11yConfiguration) {
        guard let backgroundColor = label.superview?.backgroundColor else { return }
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
            let adjustedColor = titleColor.adjustedForContrast(against: backgroundColor, targetContrast: configuration.minimumContrastRatio)
            button.setTitleColor(adjustedColor, for: .normal)
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
    
    func audit(_ view: UIView, with configuration: A11yConfiguration) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if let label = view as? UILabel,
           let backgroundColor = label.superview?.backgroundColor {
            let contrast = label.textColor.contrastRatio(with: backgroundColor)
            if contrast < configuration.minimumContrastRatio {
                issues.append(A11yIssue(view: label, issueType: .colorContrast, description: "Insufficient color contrast for label: \(contrast)"))
            }
        }
        
        if let button = view as? UIButton,
           let titleColor = button.titleColor(for: .normal),
           let backgroundColor = button.backgroundColor ?? button.superview?.backgroundColor {
            let contrast = titleColor.contrastRatio(with: backgroundColor)
            if contrast < configuration.minimumContrastRatio {
                issues.append(A11yIssue(view: button, issueType: .colorContrast, description: "Insufficient color contrast for button: \(contrast)"))
            }
        }
        
        if let textField = view as? UITextField,
           let textColor = textField.textColor,
           let backgroundColor = textField.backgroundColor ?? textField.superview?.backgroundColor {
            let contrast = textColor.contrastRatio(with: backgroundColor)
            if contrast < configuration.minimumContrastRatio {
                issues.append(A11yIssue(view: textField, issueType: .colorContrast, description: "Insufficient color contrast for text field: \(contrast)"))
            }
        }
        
        return issues
    }
}
