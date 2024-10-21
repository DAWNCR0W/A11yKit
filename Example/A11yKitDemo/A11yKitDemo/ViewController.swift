//
//  ViewController.swift
//  A11yKitDemo
//
//  Created by dawncr0w on 10/21/24.
//

import UIKit
import A11yKit

class ViewController: UIViewController {
    @IBOutlet var testLabel: UILabel!
    @IBOutlet var testButton: UIButton!
    @IBOutlet var testTextField: UITextField!
    @IBOutlet var testImageView: UIImageView!
    @IBOutlet var testView: UIView!
    
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
        
        print("----")
        
        a11y.optimizeAll(self)
        
        let reportAfter = a11y.generateAccessibilityReport(for: self)
        print(reportAfter)
    }


}

