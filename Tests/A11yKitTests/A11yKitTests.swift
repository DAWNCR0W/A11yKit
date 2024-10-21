//
//  A11yKitTests.swift
//  A11yKitTests
//
//  Created by dawncr0w on 10/21/24.
//

import XCTest
@testable import A11yKit

final class A11yKitTests: XCTestCase {
    
    var a11yKit: A11yKit!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        a11yKit = A11yKit.shared
        a11yKit.configuration = A11yConfiguration()
    }
    
    override func tearDownWithError() throws {
        a11yKit = nil
        try super.tearDownWithError()
    }
    
    func testOptimizeView() {
        let view = UIView()
        a11yKit.optimize(view)
        XCTAssertTrue(view.isAccessibilityElement)
    }
    
    func testOptimizeLabel() {
        let label = UILabel()
        label.text = "Test Label"
        a11yKit.optimize(label)
        XCTAssertTrue(label.isAccessibilityElement)
        XCTAssertEqual(label.accessibilityLabel, "Test Label")
        XCTAssertTrue(label.adjustsFontForContentSizeCategory)
    }
    
    func testOptimizeButton() {
        let button = UIButton()
        button.setTitle("Test Button", for: .normal)
        a11yKit.optimize(button)
        XCTAssertTrue(button.isAccessibilityElement)
        XCTAssertEqual(button.accessibilityLabel, "Test Button")
        XCTAssertTrue(button.titleLabel?.adjustsFontForContentSizeCategory ?? false)
    }
    
    func testOptimizeTextField() {
        let textField = UITextField()
        textField.placeholder = "Test Placeholder"
        a11yKit.optimize(textField)
        XCTAssertTrue(textField.isAccessibilityElement)
        XCTAssertEqual(textField.accessibilityLabel, "Test Placeholder")
        XCTAssertTrue(textField.adjustsFontForContentSizeCategory)
    }
    
    func testColorContrastOptimization() {
        let label = UILabel()
        label.text = "Test Label"
        label.textColor = .lightGray
        label.backgroundColor = .white
        
        a11yKit.configuration.minimumContrastRatio = 4.5
        a11yKit.optimize(label, options: .colorContrast)
        
        XCTAssertNotEqual(label.textColor, .lightGray)
        XCTAssertGreaterThanOrEqual(label.textColor.contrastRatio(with: .white), 4.5)
    }
    
    func testVoiceOverOptimization() {
        let button = UIButton()
        button.setTitle("Test Button", for: .normal)
        
        a11yKit.optimize(button, options: .voiceOver)
        
        XCTAssertTrue(button.isAccessibilityElement)
        XCTAssertEqual(button.accessibilityLabel, "Test Button")
        XCTAssertTrue(button.accessibilityTraits.contains(.button))
    }
    
    func testDynamicTypeOptimization() {
        let label = UILabel()
        label.text = "Test Label"
        label.font = UIFont.systemFont(ofSize: 14)
        
        a11yKit.optimize(label, options: .dynamicType)
        
        XCTAssertTrue(label.adjustsFontForContentSizeCategory)
        XCTAssertNotNil(label.font.fontDescriptor.object(forKey: .textStyle))
    }
    
    func testAccessibilityAudit() {
        let viewController = UIViewController()
        let label = UILabel()
        label.text = "Test Label"
        label.textColor = .lightGray
        label.backgroundColor = .white
        viewController.view.addSubview(label)
        
        let issues = a11yKit.performAccessibilityAudit(on: viewController)
        
        XCTAssertFalse(issues.isEmpty)
        XCTAssertTrue(issues.contains { $0.issueType == .colorContrast })
    }
    
    func testConfigurationUpdate() {
        a11yKit.configuration.minimumContrastRatio = 7.0
        a11yKit.configuration.enableDynamicType = false
        
        XCTAssertEqual(a11yKit.configuration.minimumContrastRatio, 7.0)
        XCTAssertFalse(a11yKit.configuration.enableDynamicType)
    }
    
    func testOptimizationOptions() {
        let options: OptimizationOptions = [.voiceOver, .dynamicType]
        
        XCTAssertTrue(options.contains(.voiceOver))
        XCTAssertTrue(options.contains(.dynamicType))
        XCTAssertFalse(options.contains(.colorContrast))
    }
}
