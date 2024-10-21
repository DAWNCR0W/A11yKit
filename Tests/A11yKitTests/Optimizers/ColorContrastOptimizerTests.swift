//
//  ColorContrastOptimizerTests.swift
//  A11yKitTests
//
//  Created by dawncr0w on 10/21/24.
//

import XCTest
@testable import A11yKit

class ColorContrastOptimizerTests: XCTestCase {
    
    var optimizer: ColorContrastOptimizer!
    var configuration: A11yConfiguration!
    
    override func setUp() {
        super.setUp()
        optimizer = ColorContrastOptimizer()
        configuration = A11yConfiguration()
        configuration.minimumContrastRatio = 4.5
    }
    
    override func tearDown() {
        optimizer = nil
        configuration = nil
        super.tearDown()
    }
    
    func testOptimizeLabel() {
        let label = UILabel()
        label.text = "Test Label"
        label.textColor = .lightGray
        label.backgroundColor = .white
        
        optimizer.optimize(label, with: configuration)
        
        XCTAssertGreaterThanOrEqual(label.textColor.contrastRatio(with: .white), configuration.minimumContrastRatio)
    }
    
    func testOptimizeButton() {
        let button = UIButton()
        button.setTitle("Test Button", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.backgroundColor = .white
        
        optimizer.optimize(button, with: configuration)
        
        XCTAssertGreaterThanOrEqual(button.titleColor(for: .normal)?.contrastRatio(with: .white) ?? 0, configuration.minimumContrastRatio)
    }
    
    func testOptimizeTextField() {
        let textField = UITextField()
        textField.textColor = .lightGray
        textField.backgroundColor = .white
        
        optimizer.optimize(textField, with: configuration)
        
        XCTAssertGreaterThanOrEqual(textField.textColor?.contrastRatio(with: .white) ?? 0, configuration.minimumContrastRatio)
    }
    
    func testNoOptimizationNeeded() {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .white
        
        optimizer.optimize(label, with: configuration)
        
        XCTAssertEqual(label.textColor, .black)
    }
    
    func testAuditWithIssues() {
        let view = UIView()
        let label = UILabel()
        label.text = "Test Label"
        label.textColor = .lightGray
        label.backgroundColor = .white
        view.addSubview(label)
        
        let issues = optimizer.audit(view, with: configuration)
        
        XCTAssertFalse(issues.isEmpty)
        XCTAssertEqual(issues.first?.issueType, .colorContrast)
        XCTAssertTrue(issues.first?.description.contains("Insufficient color contrast") ?? false)
    }
    
    func testAuditWithoutIssues() {
        let view = UIView()
        let label = UILabel()
        label.text = "Test Label"
        label.textColor = .black
        label.backgroundColor = .white
        view.addSubview(label)
        
        let issues = optimizer.audit(view, with: configuration)
        
        XCTAssertTrue(issues.isEmpty)
    }
}
