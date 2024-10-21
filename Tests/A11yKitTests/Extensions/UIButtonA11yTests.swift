//
//  UIButtonA11yTests.swift
//  A11yKitTests
//
//  Created by dawncr0w on 10/21/24.
//

import XCTest
@testable import A11yKit

class UIButtonA11yTests: XCTestCase {
    
    var button: UIButton!
    
    override func setUp() {
        super.setUp()
        button = UIButton(type: .system)
        button.setTitle("Test Button", for: .normal)
    }
    
    override func tearDown() {
        button = nil
        super.tearDown()
    }
    
    func testA11yOptimizeForDynamicType() {
        button.a11y_optimizeForDynamicType()
        
        XCTAssertTrue(button.titleLabel?.adjustsFontForContentSizeCategory ?? false)
        XCTAssertNotNil(button.titleLabel?.font.fontDescriptor.object(forKey: .textStyle))
    }
    
    func testA11ySetAccessibleFont() {
        button.a11y_setAccessibleFont(style: .headline)
        
        XCTAssertTrue(button.titleLabel?.adjustsFontForContentSizeCategory ?? false)
        XCTAssertEqual(button.titleLabel?.font, UIFont.preferredFont(forTextStyle: .headline))
    }
    
    func testA11yOptimizeContrast() {
        button.setTitleColor(.lightGray, for: .normal)
        button.backgroundColor = .white
        
        button.a11y_optimizeContrast()
        
        XCTAssertGreaterThanOrEqual(button.titleColor(for: .normal)?.contrastRatio(with: .white) ?? 0, A11yKit.shared.configuration.minimumContrastRatio)
    }
    
    func testA11yMakeAccessible() {
        button.a11y_makeAccessible(prefix: "Action: ", suffix: " (Tap to activate)")
        
        XCTAssertTrue(button.isAccessibilityElement)
        XCTAssertEqual(button.accessibilityLabel, "Action: Test Button (Tap to activate)")
        XCTAssertTrue(button.accessibilityTraits.contains(.button))
    }
}
