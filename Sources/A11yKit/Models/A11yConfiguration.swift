//
//  A11yConfiguration.swift
//  A11yKit
//
//  Created by dawncr0w on 10/21/24.
//

import UIKit

public struct A11yConfiguration {
    // MARK: - Default Configuration
    @MainActor public static let `default` = A11yConfiguration()
    
    // MARK: - General Settings
    public var isEnabled: Bool = true
    public var logLevel: LogLevel = .info
    
    // MARK: - VoiceOver Settings
    public var autoGenerateVoiceOverLabels: Bool = true
    public var voiceOverLabelPrefix: String = ""
    public var voiceOverLabelSuffix: String = ""
    
    // MARK: - Dynamic Type Settings
    public var enableDynamicType: Bool = true
    public var minimumContentSizeCategory: UIContentSizeCategory = .small
    public var maximumContentSizeCategory: UIContentSizeCategory = .accessibilityExtraExtraExtraLarge
    public var enableLargeContentViewer: Bool = true
    public var preferredContentSizeCategory: UIContentSizeCategory? = nil
    
    // MARK: - Color Contrast Settings
    public var enableColorContrastOptimization: Bool = true
    public var minimumContrastRatio: CGFloat = 4.5 {
        didSet {
            minimumContrastRatio = max(1.0, min(minimumContrastRatio, 21.0))
            preferredContrastRatio = max(preferredContrastRatio, minimumContrastRatio)
        }
    } // WCAG AA standard
    public var preferredContrastRatio: CGFloat = 7.0 {
        didSet {
            preferredContrastRatio = max(minimumContrastRatio, min(preferredContrastRatio, 21.0))
        }
    } // WCAG AAA standard
    
    // MARK: - Custom Settings
    public var customSettings: [String: Any] = [:]
    
    public init() {}
    
    public mutating func updateSetting<T>(_ keyPath: WritableKeyPath<A11yConfiguration, T>, value: T) {
        self[keyPath: keyPath] = value
    }
    
    public func getSetting<T>(_ keyPath: KeyPath<A11yConfiguration, T>) -> T {
        return self[keyPath: keyPath]
    }
    
    public mutating func setCustomSetting(_ key: String, value: Any) {
        customSettings[key] = value
    }
    
    public func getCustomSetting<T>(_ key: String) -> T? {
        return customSettings[key] as? T
    }
    
    public mutating func reset() {
        self = A11yConfiguration()
    }
}

extension A11yConfiguration: CustomStringConvertible {
    public var description: String {
        return """
        A11yConfiguration:
        - Enabled: \(isEnabled)
        - Log Level: \(logLevel)
        - Auto Generate VoiceOver Labels: \(autoGenerateVoiceOverLabels)
        - Enable Dynamic Type: \(enableDynamicType)
        - Preferred Content Size Category: \(preferredContentSizeCategory?.rawValue ?? "nil")
        - Enable Color Contrast Optimization: \(enableColorContrastOptimization)
        - Minimum Contrast Ratio: \(minimumContrastRatio)
        - Custom Settings: \(customSettings)
        """
    }
}
