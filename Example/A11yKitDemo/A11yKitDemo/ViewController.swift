//
//  ViewController.swift
//  A11yKitDemo
//
//  Created by dawncr0w on 10/21/24.
//

import UIKit
import A11yKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let a11y = A11yKit.shared
        
        // Configure A11yKit
        a11y.isLoggingEnabled = true
        a11y.minimumContrastRatio = 7.0 // WCAG AAA standard
        a11y.preferredContentSizeCategory = .large
        
        // Optimize with specific options
        a11y.optimizeAll(self, options: [.voiceOver, .dynamicType])
        
        // Optimize a specific view
        if let specialView = view.viewWithTag(100) {
            a11y.optimizeColorContrast(for: specialView)
        }
        
        // Generate an accessibility report
        let report = a11y.generateAccessibilityReport(for: self)
        print(report)
    }


}

