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
    @IBOutlet var actionSegmentedControl: UISegmentedControl!
    @IBOutlet var optionSegmentedControl: UISegmentedControl!
    @IBOutlet var resultTextView: UITextView!
    
    let a11y = A11yKit.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupA11yKit()
        
        a11y.optimizeAll(self)
        
        a11y.addAutoExcludedClassPrefix("MyApp_Internal")
        
        a11y.removeAutoExcludedClassPrefix("UIStatusBar")
    }
    
    func setupUI() {
        actionSegmentedControl.removeAllSegments()
        actionSegmentedControl.insertSegment(withTitle: "Optimize", at: 0, animated: false)
        actionSegmentedControl.insertSegment(withTitle: "Audit", at: 1, animated: false)
        actionSegmentedControl.insertSegment(withTitle: "Report", at: 2, animated: false)
        actionSegmentedControl.insertSegment(withTitle: "Undo", at: 3, animated: false)
        actionSegmentedControl.selectedSegmentIndex = 0
        
        optionSegmentedControl.removeAllSegments()
        optionSegmentedControl.insertSegment(withTitle: "VoiceOver", at: 0, animated: false)
        optionSegmentedControl.insertSegment(withTitle: "DynamicType", at: 1, animated: false)
        optionSegmentedControl.insertSegment(withTitle: "ColorContrast", at: 2, animated: false)
        optionSegmentedControl.insertSegment(withTitle: "All", at: 3, animated: false)
        optionSegmentedControl.selectedSegmentIndex = 3
        
        testButton.addTarget(self, action: #selector(performAction), for: .touchUpInside)
    }
    
    func setupA11yKit() {
        a11y.setLoggingEnabled(true)
        
        var config = A11yConfiguration()
        config.minimumContrastRatio = 7.0 // WCAG AAA standard
        config.preferredContentSizeCategory = .large
        config.autoGenerateVoiceOverLabels = true
        config.enableDynamicType = true
        config.enableColorContrastOptimization = true
        a11y.updateConfiguration(config)
    }
    
    @objc func performAction() {
        let action = actionSegmentedControl.selectedSegmentIndex
        let option = getSelectedOption()
        
        switch action {
        case 0: // Optimize
            optimizeViews(with: option)
        case 1: // Audit
            auditViews(with: option)
        case 2: // Report
            generateReport()
        case 3: // Undo
            undoLastOptimization()
        default:
            break
        }
    }
    
    func getSelectedOption() -> OptimizationOptions {
        switch optionSegmentedControl.selectedSegmentIndex {
        case 0:
            return .voiceOver
        case 1:
            return .dynamicType
        case 2:
            return .colorContrast
        default:
            return .all
        }
    }
    
    func optimizeViews(with option: OptimizationOptions) {
        a11y.optimize(view, options: option)
        resultTextView.text = "Optimized views with option: \(option)"
    }
    
    func auditViews(with option: OptimizationOptions) {
        let issues = a11y.audit(view, options: option)
        resultTextView.text = "Found \(issues.count) issues with option: \(option)\n\n"
        for issue in issues {
            resultTextView.text += "- \(issue.description)\n"
        }
    }
    
    func generateReport() {
        let report = a11y.generateAccessibilityReport(for: self)
        resultTextView.text = report
    }
    
    func undoLastOptimization() {
        a11y.undoLastOptimization()
        resultTextView.text = "Undid last optimization"
    }
    
    func optimizeAsync() async {
        await a11y.optimizeAsync(view)
        DispatchQueue.main.async {
            self.resultTextView.text = "Async optimization completed"
        }
    }
}
