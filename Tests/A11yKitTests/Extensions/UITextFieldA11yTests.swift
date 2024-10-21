//
//  UITextFieldA11yTests.swift
//  A11yKitTests
//
//  Created by dawncr0w on 10/21/24.
//

import XCTest
@testable import A11yKit

class UITextFieldA11yTests: XCTestCase {
    
    var textField: UITextField!
    
    override func setUp() {
        super.setUp()
        textField = UITextField()
        textField.placeholder = "Enter text"
    }
    
    override func tearDown() {
        textField = nil
        super.tearDown()
    }
    
    func testA11yOptimizeForDynamicType() {
        textField.a11y_optimizeForDynamicType()
        
        XCTAssertTrue(textField.adjustsFontForContentSizeCategory)
        XCTAssertNotNil(textField.font?.fontDescriptor.object(forKey: .textStyle))
    }
    
    func testA11ySetAccessibleFont() {
        textField.a11y_setAccessibleFont(style: .body)
        
        XCTAssertTrue(textField.adjustsFontForContentSizeCategory)
        XCTAssertEqual(textField.font, UIFont.preferredFont(forTextStyle: .body))
    }
    
    func testA11yOptimizeContrast() {
        textField.textColor = .lightGray
        textField.backgroundColor = .white
        
        textField.a11y_optimizeContrast()
        
        XCTAssertGreaterThanOrEqual(textField.textColor?.contrastRatio(with: .white) ?? 0, A11yKit.shared.configuration.minimumContrastRatio)
    }
    
    func testA11yMakeAccessible() {
        textField.a11y_makeAccessible(prefix: "Input: ", suffix: " (Required)")
        
        XCTAssertTrue(textField.isAccessibilityElement)
        XCTAssertEqual(textField.accessibilityLabel, "Input: Enter text (Required)")
        XCTAssertTrue(textField.accessibilityTraits.contains(.searchField))
    }
    
    func testA11ySetAccessiblePlaceholder() {
        textField.a11y_setAccessiblePlaceholder("Enter your name")
        
        XCTAssertNotNil(textField.attributedPlaceholder)
        XCTAssertEqual(textField.attributedPlaceholder?.string, "Enter your name")
        XCTAssertTrue(textField.attributedPlaceholder?.attributes(at: 0, effectiveRange: nil).keys.contains(.accessibilitySpeechPunctuation) ?? false)
    }
}
