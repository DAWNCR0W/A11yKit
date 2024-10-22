//
//  A11yLogger.swift
//  A11yKit
//
//  Created by dawncr0w on 10/21/24.
//

import Foundation

public enum LogLevel: Int, Comparable {
    case debug = 0
    case info
    case warning
    case error
    
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

@MainActor
public class A11yLogger {
    public static var isEnabled = true
    public static var minimumLogLevel: LogLevel = .info
    
    private init() {}
    
    public static func log(_ message: String, level: LogLevel, file: String = #file, function: String = #function, line: Int = #line) {
        guard isEnabled && level >= minimumLogLevel else { return }
        
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "A11yKit [\(level)] [\(fileName):\(line)] \(function): \(message)"
        
        switch level {
        case .debug:
            print("🟣 \(logMessage)")
        case .info:
            print("🔵 \(logMessage)")
        case .warning:
            print("🟠 \(logMessage)")
        case .error:
            print("🔴 \(logMessage)")
        }
    }
    
    public static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .debug, file: file, function: function, line: line)
    }
    
    public static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .info, file: file, function: function, line: line)
    }
    
    public static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .warning, file: file, function: function, line: line)
    }
    
    public static func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        log(message, level: .error, file: file, function: function, line: line)
    }
}
