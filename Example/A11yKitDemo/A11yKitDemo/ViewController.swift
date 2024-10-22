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
        a11y.setLoggingEnabled(true)
        
        var config = A11yConfiguration()
        config.minimumContrastRatio = 7.0 // WCAG AAA standard
        config.preferredContentSizeCategory = .large
        a11y.updateConfiguration(config)
        
        // Optimize with specific options
        a11y.optimizeAll(self, options: [.voiceOver, .dynamicType, .colorContrast])
        
        // Optimize a specific view
        if let specialView = view.viewWithTag(100) {
            a11y.optimize(specialView, options: .colorContrast)
        }
        
        // Generate an accessibility report
        let report = a11y.generateAccessibilityReport(for: self)
        print(report)
        
        // Perform an accessibility audit
        let issues = a11y.auditAll(self)
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
