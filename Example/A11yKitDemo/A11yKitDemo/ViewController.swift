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
        a11y.setPreferredContentSizeCategory(.large)
        
        // Optimize with specific options
        a11y.optimizeAll(self, options: [.voiceOver, .dynamicType, .colorContrast])
        
        // Optimize a specific view
        if let specialView = view.viewWithTag(100) {
            a11y.optimizeColorContrast(for: specialView)
        }
        
        // Generate an accessibility report
        let report = a11y.generateAccessibilityReport(for: self)
        print(report)
        
        // Perform an accessibility audit
        let issues = a11y.performAccessibilityAudit(on: self)
        print("Found \(issues.count) accessibility issues")
        
        // Undo last optimization
        a11y.undoLastOptimization()
        
        // Get diagnostic information
        let diagnosticInfo = a11y.getDiagnosticInfo()
        print(diagnosticInfo)
    }
    
    func optimizeAsync() async {
        await A11yKit.shared.optimizeAsync(view)
    }
}

