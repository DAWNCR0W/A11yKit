//
//  A11yReporter.swift
//  A11yKit
//
//  Created by dawncr0w on 10/21/24.
//

import UIKit

@MainActor
public class A11yReporter {
    private init() {}
    
    public static func generateReport(for viewController: UIViewController) -> String {
        var report = "A11yKit Accessibility Report\n"
        report += "==============================\n\n"
        
        let issues = auditViewController(viewController)
        
        report += "Summary:\n"
        report += "- Total issues found: \(issues.count)\n"
        report += "- VoiceOver issues: \(issues.filter { $0.issueType == .voiceOver }.count)\n"
        report += "- Dynamic Type issues: \(issues.filter { $0.issueType == .dynamicType }.count)\n"
        report += "- Color Contrast issues: \(issues.filter { $0.issueType == .colorContrast }.count)\n\n"
        
        report += "Detailed Issues:\n"
        for (index, issue) in issues.enumerated() {
            report += "\(index + 1). [\(issue.issueType)] \(issue.description)\n"
            report += "   View: \(type(of: issue.view)), Accessibility Identifier: \(issue.view.accessibilityIdentifier ?? "N/A")\n\n"
        }
        
        return report
    }
    
    private static func auditViewController(_ viewController: UIViewController) -> [A11yIssue] {
        let voiceOverOptimizer = VoiceOverOptimizer()
        let dynamicTypeOptimizer = DynamicTypeOptimizer()
        let colorContrastOptimizer = ColorContrastOptimizer()
        let configuration = A11yKit.shared.configuration
        
        var issues: [A11yIssue] = []
        
        func auditRecursively(_ view: UIView) {
            issues.append(contentsOf: voiceOverOptimizer.audit(view))
            issues.append(contentsOf: dynamicTypeOptimizer.audit(view, with: configuration))
            issues.append(contentsOf: colorContrastOptimizer.audit(view, with: configuration))
            
            for subview in view.subviews {
                auditRecursively(subview)
            }
        }
        
        auditRecursively(viewController.view)
        return issues
    }
}
