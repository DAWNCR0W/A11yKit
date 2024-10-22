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

    override func setUpWithError() throws {
        textField = UITextField()
    }

    func testOptimizeForDynamicType() throws {
        textField.a11y_optimizeForDynamicType()
        XCTAssertTrue(textField.adjustsFontForContentSizeCategory)
        if let font = textField.font {
            let scaledFont = UIFontMetrics.default.scaledFont(for: font)
            XCTAssertEqual(textField.font, scaledFont)
        } else {
            XCTAssertEqual(textField.font, UIFont.preferredFont(forTextStyle: .body))
        }
    }

    func testSetAccessibleFont() throws {
        textField.a11y_setAccessibleFont(style: .headline)
        XCTAssertEqual(textField.font, UIFont.preferredFont(forTextStyle: .headline))
        XCTAssertTrue(textField.adjustsFontForContentSizeCategory)
    }

    func testOptimizeContrast() throws {
        textField.textColor = .lightGray
        textField.backgroundColor = .white
        textField.a11y_optimizeContrast()
        
        let contrastRatio = textField.textColor?.contrastRatio(with: textField.backgroundColor ?? .white)
        XCTAssertGreaterThanOrEqual(contrastRatio ?? 0, A11yKit.shared.minimumContrastRatio)
    }

    func testMakeAccessible() throws {
        textField.placeholder = "Enter your name"
        textField.a11y_makeAccessible(prefix: "Input", fallbackText: "Text Field")
        XCTAssertEqual(textField.accessibilityLabel, "InputEnter your name")
    }

    func testSetAccessiblePlaceholderWithColor() throws {
        textField.a11y_setAccessiblePlaceholder("Accessible Placeholder", color: .red)
        let placeholderAttributes = textField.attributedPlaceholder?.attributes(at: 0, effectiveRange: nil)
        
        XCTAssertEqual(textField.attributedPlaceholder?.string, "Accessible Placeholder")
        XCTAssertEqual(placeholderAttributes?[.foregroundColor] as? UIColor, .red)
    }

    func testSetAccessiblePlaceholderWithoutColor() throws {
        textField.a11y_setAccessiblePlaceholder("Accessible Placeholder")
        XCTAssertEqual(textField.attributedPlaceholder?.string, "Accessible Placeholder")
    }
}
