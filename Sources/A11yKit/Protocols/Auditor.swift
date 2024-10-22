//
//  Auditor.swift
//  A11yKit
//
//  Created by dawncr0w on 10/22/24.
//

import UIKit

protocol Auditor {
    func audit(_ view: UIView, with configuration: A11yConfiguration) -> [A11yIssue]
}
