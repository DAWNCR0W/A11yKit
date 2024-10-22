//
//  A11yKit.swift
//  A11yKit
//
//  Created by dawncr0w on 10/21/24.
//

import UIKit

public enum A11yInfo {
    public static let version = "0.1.2"
}

@MainActor
public class A11yKit {
    // MARK: - Singleton
    public static let shared = A11yKit()
    private init() {}
    
    // MARK: - Configuration
    public var configuration = A11yConfiguration()
    
    // MARK: - Properties
    public var isLoggingEnabled: Bool {
        get { return A11yLogger.isEnabled }
        set { A11yLogger.isEnabled = newValue }
    }
    
    // MARK: - Optimizers and Auditors
    private let voiceOverOptimizer = VoiceOverOptimizer()
    private let voiceOverAuditor = VoiceOverAuditor()
    private let dynamicTypeOptimizer = DynamicTypeOptimizer()
    private let dynamicTypeAuditor = DynamicTypeAuditor()
    private let colorContrastOptimizer = ColorContrastOptimizer()
    private let colorContrastAuditor = ColorContrastAuditor()
    
    // MARK: - Undo stack
    private var optimizationStack: [(UIView, OptimizationOptions)] = []
    
    // MARK: - Main Optimization Methods
    
    public func optimize(_ view: UIView, options: OptimizationOptions = .all) {
        guard !type(of: view).description().hasPrefix("_") else { return }
        
        if options.contains(.voiceOver) {
            voiceOverOptimizer.optimize(view, with: configuration)
        }
        if options.contains(.dynamicType) {
            dynamicTypeOptimizer.optimize(view, with: configuration)
        }
        if options.contains(.colorContrast) {
            colorContrastOptimizer.optimize(view, with: configuration)
        }
        A11yLogger.log("Optimized \(type(of: view))", level: .info)
        
        optimizationStack.append((view, options))
    }
    
    public func optimizeAsync(_ view: UIView, options: OptimizationOptions = .all) async {
        await Task { @MainActor in
            self.optimize(view, options: options)
        }.value
    }
    
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
    
    // MARK: - Audit Methods
    
    public func audit(_ view: UIView, options: OptimizationOptions = .all) -> [A11yIssue] {
        var issues: [A11yIssue] = []
        
        if options.contains(.voiceOver) {
            issues.append(contentsOf: voiceOverAuditor.audit(view, with: configuration))
        }
        if options.contains(.dynamicType) {
            issues.append(contentsOf: dynamicTypeAuditor.audit(view, with: configuration))
        }
        if options.contains(.colorContrast) {
            issues.append(contentsOf: colorContrastAuditor.audit(view, with: configuration))
        }
        
        return issues
    }
    
    public func auditAll(_ viewController: UIViewController, options: OptimizationOptions = .all) -> [A11yIssue] {
        return auditRecursively(viewController.view, options: options)
    }
    
    private func auditRecursively(_ view: UIView, options: OptimizationOptions) -> [A11yIssue] {
        var issues = audit(view, options: options)
        
        for subview in view.subviews {
            issues.append(contentsOf: auditRecursively(subview, options: options))
        }
        
        return issues
    }
    
    // MARK: - Utility Methods
    
    public func resetAccessibilityProperties(for view: UIView) {
        view.accessibilityLabel = nil
        view.accessibilityHint = nil
        view.accessibilityTraits = .none
        view.isAccessibilityElement = false
        A11yLogger.log("Reset accessibility properties for \(type(of: view))", level: .info)
    }
    
    public func generateAccessibilityReport(for viewController: UIViewController) -> String {
        return A11yReporter.generateReport(for: viewController)
    }
    
    // MARK: - Configuration Methods
    
    public func updateConfiguration(_ config: A11yConfiguration) {
        self.configuration = config
        A11yLogger.log("Updated A11yKit configuration", level: .info)
    }
    
    public func setLoggingEnabled(_ enabled: Bool) {
        isLoggingEnabled = enabled
        A11yLogger.log("Logging \(enabled ? "enabled" : "disabled")", level: .info)
    }
    
    // MARK: - Undo Methods
    
    public func undoLastOptimization() {
        guard let (view, _) = optimizationStack.popLast() else { return }
        resetAccessibilityProperties(for: view)
        A11yLogger.log("Undid last optimization for \(type(of: view))", level: .info)
    }
    
    // MARK: - Diagnostic Info
    
    public func getDiagnosticInfo() -> String {
        return """
            A11yKit Diagnostic Info:
            Version: \(A11yInfo.version)
            Configuration: \(configuration)
            Optimized Views: \(optimizationStack.count)
            """
    }
}
