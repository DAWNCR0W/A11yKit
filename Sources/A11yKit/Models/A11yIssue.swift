//
//  A11yIssue.swift
//  A11yKit
//
//  Created by dawncr0w on 10/22/24.
//

import UIKit

public struct A11yIssue {
    public enum Severity {
        case low, medium, high
    }
    
    public let view: UIView
    public let issueType: IssueType
    public let description: String
    public let severity: Severity
    public let suggestion: String?
    
    public enum IssueType {
        case colorContrast
        case voiceOver
        case dynamicType
    }
    
    public init(view: UIView, issueType: IssueType, description: String, severity: Severity, suggestion: String?) {
        self.view = view
        self.issueType = issueType
        self.description = description
        self.severity = severity
        self.suggestion = suggestion
    }
}
