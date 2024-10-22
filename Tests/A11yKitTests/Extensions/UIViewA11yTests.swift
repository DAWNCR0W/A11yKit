//
//  UIViewA11yTests.swift
//  A11yKitTests
//
//  Created by dawncr0w on 10/21/24.
//

import XCTest
@testable import A11yKit

class UIViewA11yTests: XCTestCase {

    var testView: UIView!
    var button: UIButton!
    var label: UILabel!
    var textField: UITextField!

    override func setUpWithError() throws {
        testView = UIView()
        button = UIButton(type: .system)
        label = UILabel()
        textField = UITextField()
        testView.addSubview(button)
        testView.addSubview(label)
        testView.addSubview(textField)
    }

    func testMakeAccessible() throws {
        testView.a11y_makeAccessible(label: "Test View", hint: "Hint for Test View", traits: .button)
        XCTAssertTrue(testView.isAccessibilityElement)
        XCTAssertEqual(testView.accessibilityLabel, "Test View")
        XCTAssertEqual(testView.accessibilityHint, "Hint for Test View")
        XCTAssertTrue(testView.accessibilityTraits.contains(.button))
    }

    func testHideAccessibility() throws {
        testView.a11y_hide()
        XCTAssertFalse(testView.isAccessibilityElement)
        XCTAssertTrue(testView.accessibilityElementsHidden)
    }

    func testShowAccessibility() throws {
        testView.a11y_show()
        XCTAssertTrue(testView.isAccessibilityElement)
        XCTAssertFalse(testView.accessibilityElementsHidden)
    }

    func testAccessibilityElementToggle() throws {
        testView.a11y_isAccessibilityElement = true
        XCTAssertTrue(testView.isAccessibilityElement)
        
        testView.a11y_isAccessibilityElement = false
        XCTAssertFalse(testView.isAccessibilityElement)
    }

    func testAddCustomAccessibilityAction() throws {
        var customActionTriggered = false
        testView.a11y_addCustomAction("Custom Action") {
            customActionTriggered = true
        }
        
        let customActions = testView.accessibilityCustomActions
        XCTAssertEqual(customActions?.count, 1)
        
        let action = customActions?.first
        XCTAssertEqual(action?.name, "Custom Action")
        
        action?.action?(action!)
        XCTAssertTrue(customActionTriggered)
    }

    func testOptimizeViewAccessibility() throws {
        A11yKit.shared.configuration.logLevel = .debug
        testView.a11y_optimize(options: .voiceOver)
        XCTAssertTrue(testView.isAccessibilityElement)
    }
}
