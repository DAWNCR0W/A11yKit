//
//  OptimizationOptions.swift
//  A11yKit
//
//  Created by dawncr0w on 10/21/24.
//

import Foundation

public struct OptimizationOptions: OptionSet {
    public let rawValue: Int
    
    public static let voiceOver = OptimizationOptions(rawValue: 1 << 0)
    public static let dynamicType = OptimizationOptions(rawValue: 1 << 1)
    public static let colorContrast = OptimizationOptions(rawValue: 1 << 2)
    
    public static let all: OptimizationOptions = [.voiceOver, .dynamicType, .colorContrast]
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension OptimizationOptions: CustomStringConvertible {
    public var description: String {
        var components: [String] = []
        if contains(.voiceOver) { components.append("VoiceOver") }
        if contains(.dynamicType) { components.append("DynamicType") }
        if contains(.colorContrast) { components.append("ColorContrast") }
        return components.isEmpty ? "[]" : "[\(components.joined(separator: ", "))]"
    }
}
