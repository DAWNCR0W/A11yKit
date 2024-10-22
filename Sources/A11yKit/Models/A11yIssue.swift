//
//  A11yIssue.swift
//  A11yKit
//
//  Created by 서동혁 on 10/22/24.
//

import UIKit

struct A11yIssue {
    enum Severity {
        case low, medium, high
    }
    
    let view: UIView
    let issueType: IssueType
    let description: String
    let severity: Severity
    let suggestion: String?
    
    enum IssueType {
        case colorContrast
        case voiceOver
        case dynamicType
    }
}
