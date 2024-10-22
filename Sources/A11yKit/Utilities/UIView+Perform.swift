//
//  UIView+Perform.swift
//  A11yKit
//
//  Created by dawncr0w on 10/22/24.
//

import UIKit

extension UIView {
    func shouldPerformAccessibilityOptimization(with configuration: A11yConfiguration) -> Bool {
        guard !isHidden && alpha > 0.01 else { return false }
        guard bounds.size.width >= configuration.minimumViewSize.width &&
              bounds.size.height >= configuration.minimumViewSize.height else { return false }
        guard !configuration.excludedViewTags.contains(tag) else { return false }
        guard !configuration.excludedViewClasses.contains(where: { isKind(of: $0) }) else { return false }
        
        let className = String(describing: type(of: self))
        guard !configuration.autoExcludedClassPrefixes.contains(where: { className.hasPrefix($0) }) else { return false }
        
        return true
    }
}
