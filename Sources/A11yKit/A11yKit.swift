//
//  A11yKit.swift
//  A11yKit
//
//  Created by dawncr0w on 10/21/24.
//

import Foundation
import UIKit

public class A11yKit {
    // MARK: - Singleton
    public static let shared = A11yKit()
    private init() {}
    
    // MARK: - Configuration
    public var configuration = A11yConfiguration()
    
    // MARK: - Optimizers
    private let voiceOverOptimizer = VoiceOverOptimizer()
    private let dynamicTypeOptimizer = DynamicTypeOptimizer()
    private let colorContrastOptimizer = ColorContrastOptimizer()
    
    // MARK: - Main Optimization Methods
    
    /// Optimizes a single view for accessibility
    /// - Parameters:
    ///   - view: The view to optimize
    ///   - options: The optimization options to apply
    public func optimize(_ view: UIView, options: OptimizationOptions = .all) {
        if options.contains(.voiceOver) {
            voiceOverOptimizer.optimize(view)
        }
        if options.contains(.dynamicType) {
            dynamicTypeOptimizer.optimize(view, with: configuration)
        }
        if options.contains(.colorContrast) {
            colorContrastOptimizer.optimize(view, with: configuration)
        }
        A11yLogger.log("Optimized \(type(of: view))", level: .info)
    }
    
    /// Optimizes all views in a view controller
    /// - Parameters:
    ///   - viewController: The view controller whose views to optimize
    ///   - options: The optimization options to apply
    public func optimizeAll(_ viewController: UIViewController, options: OptimizationOptions = .all) {
        optimizeRecursively(viewController.view, options: options)
        A11yLogger.log("Optimized all views in \(type(of: viewController))", level: .info)
    }
    
    private func optimizeRecursively(_ view: UIView, options: OptimizationOptions) {
        optimize(view, options: options)
        for subview in view.subviews {
            optimizeRecursively(subview, options: options)
        }
    }
    
    // MARK: - Specific Optimization Methods
    
    /// Optimizes a view for VoiceOver
    /// - Parameter view: The view to optimize
    public func optimizeVoiceOver(for view: UIView) {
        voiceOverOptimizer.optimize(view)
        A11yLogger.log("Optimized VoiceOver for \(type(of: view))", level: .info)
    }
    
    /// Optimizes a view for Dynamic Type
    /// - Parameter view: The view to optimize
    public func optimizeDynamicType(for view: UIView) {
        dynamicTypeOptimizer.optimize(view, with: configuration)
        A11yLogger.log("Optimized Dynamic Type for \(type(of: view))", level: .info)
    }
    
    /// Optimizes a view's color contrast
    /// - Parameter view: The view to optimize
    public func optimizeColorContrast(for view: UIView) {
        colorContrastOptimizer.optimize(view, with: configuration)
        A11yLogger.log("Optimized Color Contrast for \(type(of: view))", level: .info)
    }
    
    // MARK: - Utility Methods
    
    /// Resets accessibility properties for a view
    /// - Parameter view: The view to reset
    public func resetAccessibilityProperties(for view: UIView) {
        view.accessibilityLabel = nil
        view.accessibilityHint = nil
        view.accessibilityTraits = .none
        view.isAccessibilityElement = false
        A11yLogger.log("Reset accessibility properties for \(type(of: view))", level: .info)
    }
    
    /// Generates an accessibility report for a view controller
    /// - Parameter viewController: The view controller to generate the report for
    /// - Returns: A string containing the accessibility report
    public func generateAccessibilityReport(for viewController: UIViewController) -> String {
        return A11yReporter.generateReport(for: viewController)
    }
    
    // MARK: - Audit Methods
    
    /// Performs an accessibility audit on a view controller
    /// - Parameter viewController: The view controller to audit
    /// - Returns: An array of accessibility issues found
    public func performAccessibilityAudit(on viewController: UIViewController) -> [A11yIssue] {
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
    
    // MARK: - Configuration Methods
    
    /// Updates the A11yKit configuration
    /// - Parameter config: The new configuration to apply
    public func updateConfiguration(_ config: A11yConfiguration) {
        self.configuration = config
        A11yLogger.log("Updated A11yKit configuration", level: .info)
    }
    
    /// Enables or disables logging
    /// - Parameter enabled: Whether logging should be enabled
    public func setLoggingEnabled(_ enabled: Bool) {
        A11yLogger.isEnabled = enabled
        A11yLogger.log("Logging \(enabled ? "enabled" : "disabled")", level: .info)
    }
}

// MARK: - Supporting Types

public struct A11yIssue {
    public let view: UIView
    public let issueType: IssueType
    public let description: String
    
    public enum IssueType {
        case voiceOver
        case dynamicType
        case colorContrast
    }
}
