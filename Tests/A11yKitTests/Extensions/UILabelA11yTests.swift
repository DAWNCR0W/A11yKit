//
//  UILabelA11yTests.swift
//  A11yKitTests
//
//  Created by dawncr0w on 10/21/24.
//

import XCTest
@testable import A11yKit

class UILabelA11yTests: XCTestCase {

    var label: UILabel!

    override func setUpWithError() throws {
        label = UILabel()
    }

    func testOptimizeForDynamicType() throws {
        label.a11y_optimizeForDynamicType()
        XCTAssertTrue(label.adjustsFontForContentSizeCategory)
        
        if let currentFont = label.font {
            let scaledFont = UIFontMetrics.default.scaledFont(for: currentFont)
            XCTAssertEqual(label.font, scaledFont)
        } else {
            XCTAssertEqual(label.font, UIFont.preferredFont(forTextStyle: .body))
        }
    }

    func testSetAccessibleFont() throws {
        label.a11y_setAccessibleFont(style: .title1)
        XCTAssertEqual(label.font, UIFont.preferredFont(forTextStyle: .title1))
        XCTAssertTrue(label.adjustsFontForContentSizeCategory)
    }

    func testOptimizeContrast() throws {
        label.textColor = .lightGray
        label.backgroundColor = .white
        label.a11y_optimizeContrast(against: label.backgroundColor ?? .white)
        
        let contrastRatio = label.textColor?.contrastRatio(with: label.backgroundColor ?? .white)
        XCTAssertGreaterThanOrEqual(contrastRatio ?? 0, A11yKit.shared.minimumContrastRatio)
    }

    func testMakeAccessible() throws {
        label.text = "Label Text"
        label.a11y_makeAccessible(prefix: "Prefix: ", suffix: " Suffix", fallbackText: "Default Label")
        XCTAssertEqual(label.accessibilityLabel, "Prefix: Label Text Suffix")
    }

    func testMakeAccessibleFallback() throws {
        label.text = nil
        label.a11y_makeAccessible(prefix: "Prefix: ", suffix: " Suffix", fallbackText: "Default Label")
        XCTAssertEqual(label.accessibilityLabel, "Prefix: Default Label Suffix")
    }
}
