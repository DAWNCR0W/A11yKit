//
//  UIColor+Contrast.swift
//  A11yKit
//
//  Created by dawncr0w on 10/21/24.
//

import UIKit

extension UIColor {
    // Calculate the contrast ratio between two colors
    func contrastRatio(with color: UIColor) -> CGFloat {
        let l1 = luminance()
        let l2 = color.luminance()
        
        let lighterLum = max(l1, l2)
        let darkerLum = min(l1, l2)
        
        return (lighterLum + 0.05) / (darkerLum + 0.05)
    }
    
    // Calculate the relative luminance of a color
    func luminance() -> CGFloat {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let rLum = adjustedColorComponent(red)
        let gLum = adjustedColorComponent(green)
        let bLum = adjustedColorComponent(blue)
        
        return 0.2126 * rLum + 0.7152 * gLum + 0.0722 * bLum
    }
    
    private func adjustedColorComponent(_ component: CGFloat) -> CGFloat {
        return component <= 0.03928 ? component / 12.92 : pow((component + 0.055) / 1.055, 2.4)
    }
    
    // Adjust color to meet a target contrast ratio against a background color
    func adjustedForContrast(against backgroundColor: UIColor, targetContrast: CGFloat) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let step: CGFloat = 0.05
        var adjustedColor = self
        let maxIterations = 40
        var iterations = 0
        
        let backgroundLuminance = backgroundColor.luminance()
        let isLighter = luminance() > backgroundLuminance
        
        while adjustedColor.contrastRatio(with: backgroundColor) < targetContrast && iterations < maxIterations {
            if isLighter {
                red = min(1, red + step)
                green = min(1, green + step)
                blue = min(1, blue + step)
            } else {
                red = max(0, red - step)
                green = max(0, green - step)
                blue = max(0, blue - step)
            }
            
            adjustedColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            iterations += 1
        }
        
        return adjustedColor
    }
    
    // Check if the color meets a minimum contrast ratio against a background color
    func meetsMinimumContrast(_ minimumContrast: CGFloat, against backgroundColor: UIColor) -> Bool {
        return contrastRatio(with: backgroundColor) >= minimumContrast
    }
}
