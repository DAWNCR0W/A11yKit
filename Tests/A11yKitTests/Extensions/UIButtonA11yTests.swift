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

    override func setUpWithError() throws {
        button = UIButton(type: .system)
    }

    func testOptimizeForDynamicType() throws {
        button.a11y_optimizeForDynamicType()
        XCTAssertTrue(button.titleLabel?.adjustsFontForContentSizeCategory ?? false)
        
        if let currentFont = button.titleLabel?.font {
            let scaledFont = UIFontMetrics.default.scaledFont(for: currentFont)
            XCTAssertEqual(button.titleLabel?.font, scaledFont)
        }
    }

    func testSetAccessibleFont() throws {
        button.a11y_setAccessibleFont(style: .title2)
        XCTAssertEqual(button.titleLabel?.font, UIFont.preferredFont(forTextStyle: .title2))
        XCTAssertTrue(button.titleLabel?.adjustsFontForContentSizeCategory ?? false)
    }

    func testOptimizeContrast() throws {
        button.setTitleColor(.lightGray, for: .normal)
        button.backgroundColor = .white

        button.a11y_optimizeContrast()
        
        let titleColor = button.titleColor(for: .normal)
        let contrastRatio = titleColor?.contrastRatio(with: button.backgroundColor ?? .white)
        XCTAssertGreaterThanOrEqual(contrastRatio ?? 0, A11yKit.shared.minimumContrastRatio)
    }

    func testMakeAccessible() throws {
        button.setTitle("Submit", for: .normal)
        button.a11y_makeAccessible(prefix: "Action: ", suffix: " button", fallbackText: "Button")
        XCTAssertEqual(button.accessibilityLabel, "Action: Submit button")
        XCTAssertTrue(button.accessibilityTraits.contains(.button))
    }

    func testMakeAccessibleFallback() throws {
        button.setTitle(nil, for: .normal)
        button.a11y_makeAccessible(prefix: "Action: ", suffix: " button", fallbackText: "Button")
        XCTAssertEqual(button.accessibilityLabel, "Action: Button button")
    }
}
