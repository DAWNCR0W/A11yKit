//
//  VoiceOverOptimizerTests.swift
//  A11yKitTests
//
//  Created by dawncr0w on 10/21/24.
//

import XCTest
@testable import A11yKit

class VoiceOverOptimizerTests: XCTestCase {
    
    var optimizer: VoiceOverOptimizer!
    
    override func setUp() {
        super.setUp()
        optimizer = VoiceOverOptimizer()
    }
    
    override func tearDown() {
        optimizer = nil
        super.tearDown()
    }
    
    func testOptimizeLabel() {
        let label = UILabel()
        label.text = "Test Label"
        
        optimizer.optimize(label)
        
        XCTAssertTrue(label.isAccessibilityElement)
        XCTAssertEqual(label.accessibilityLabel, "Test Label")
        XCTAssertTrue(label.accessibilityTraits.contains(.staticText))
    }
    
    func testOptimizeButton() {
        let button = UIButton()
        button.setTitle("Test Button", for: .normal)
        
        optimizer.optimize(button)
        
        XCTAssertTrue(button.isAccessibilityElement)
        XCTAssertEqual(button.accessibilityLabel, "Test Button")
        XCTAssertTrue(button.accessibilityTraits.contains(.button))
    }
    
    func testOptimizeImageView() {
        let imageView = UIImageView()
        imageView.accessibilityIdentifier = "TestImage"
        
        optimizer.optimize(imageView)
        
        XCTAssertTrue(imageView.isAccessibilityElement)
        XCTAssertEqual(imageView.accessibilityLabel, "TestImage")
        XCTAssertTrue(imageView.accessibilityTraits.contains(.image))
    }
    
    func testOptimizeTextField() {
        let textField = UITextField()
        textField.placeholder = "Enter text"
        
        optimizer.optimize(textField)
        
        XCTAssertTrue(textField.isAccessibilityElement)
        XCTAssertEqual(textField.accessibilityLabel, "Enter text")
        XCTAssertTrue(textField.accessibilityTraits.contains(.searchField))
    }
    
    func testAuditWithIssues() {
        let view = UIView()
        let button = UIButton()
        view.addSubview(button)
        
        let issues = optimizer.audit(view)
        
        XCTAssertFalse(issues.isEmpty)
        XCTAssertEqual(issues.first?.issueType, .voiceOver)
        XCTAssertTrue(issues.first?.description.contains("Missing accessibility label") ?? false)
    }
    
    func testAuditWithoutIssues() {
        let view = UIView()
        let label = UILabel()
        label.text = "Accessible Label"
        label.isAccessibilityElement = true
        view.addSubview(label)
        
        let issues = optimizer.audit(view)
        
        XCTAssertTrue(issues.isEmpty)
    }
}
