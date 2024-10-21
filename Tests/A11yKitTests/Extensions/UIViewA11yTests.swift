//
//  UIViewA11yTests.swift
//  A11yKitTests
//
//  Created by dawncr0w on 10/21/24.
//

import XCTest
@testable import A11yKit

class UIViewA11yTests: XCTestCase {
    
    var view: UIView!
    var expectation: XCTestExpectation!
    
    override func setUp() {
        super.setUp()
        view = UIView()
    }
    
    override func tearDown() {
        view = nil
        expectation = nil
        super.tearDown()
    }
    
    func testA11yOptimize() {
        view.a11y_optimize()
        XCTAssertTrue(view.isAccessibilityElement)
    }
    
    func testA11yMakeAccessible() {
        view.a11y_makeAccessible(label: "Test View", hint: "This is a test view", traits: .button)
        
        XCTAssertTrue(view.isAccessibilityElement)
        XCTAssertEqual(view.accessibilityLabel, "Test View")
        XCTAssertEqual(view.accessibilityHint, "This is a test view")
        XCTAssertTrue(view.accessibilityTraits.contains(.button))
    }
    
    func testA11yHide() {
        view.a11y_hide()
        
        XCTAssertFalse(view.isAccessibilityElement)
        XCTAssertTrue(view.accessibilityElementsHidden)
    }
    
    func testA11yIsAccessibilityElement() {
        view.a11y_isAccessibilityElement = true
        XCTAssertTrue(view.isAccessibilityElement)
        
        view.a11y_isAccessibilityElement = false
        XCTAssertFalse(view.isAccessibilityElement)
    }
    
    func testA11yAddCustomAction() {
        expectation = self.expectation(description: "Custom action called")
        
        view.a11y_addCustomAction("Test Action", target: self, selector: #selector(customActionHandler))
        
        XCTAssertEqual(view.accessibilityCustomActions?.count, 1)
        XCTAssertEqual(view.accessibilityCustomActions?.first?.name, "Test Action")
        
        if let action = view.accessibilityCustomActions?.first {
            action.perform(#selector(customActionHandler))
        } else {
            XCTFail("No custom action found")
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    @objc func customActionHandler() {
        expectation.fulfill()
    }
}
