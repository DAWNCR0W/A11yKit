//
//  A11yReporterTests.swift
//  A11yKitTests
//
//  Created by dawncr0w on 10/21/24.
//

import XCTest
@testable import A11yKit

class A11yReporterTests: XCTestCase {
    
    var viewController: UIViewController!
    
    override func setUp() {
        super.setUp()
        viewController = UIViewController()
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    func testGenerateReport() {
        let label = UILabel()
        label.text = "Test Label"
        label.textColor = .lightGray
        label.backgroundColor = .white
        label.isAccessibilityElement = false
        
        let button = UIButton()
        button.setTitle("Test Button", for: .normal)
        button.accessibilityLabel = nil
        
        viewController.view.addSubview(label)
        viewController.view.addSubview(button)
        
        let report = A11yReporter.generateReport(for: viewController)
        
        XCTAssertTrue(report.contains("A11yKit Accessibility Report"))
        XCTAssertTrue(report.contains("Total issues found:"))
        XCTAssertTrue(report.contains("VoiceOver issues:"))
        XCTAssertTrue(report.contains("Dynamic Type issues:"))
        XCTAssertTrue(report.contains("Color Contrast issues:"))
        XCTAssertTrue(report.contains("UILabel"))
        XCTAssertTrue(report.contains("UIButton"))
    }
    
    func testReportWithNoIssues() {
        let label = UILabel()
        label.text = "Perfect Label"
        label.textColor = .black
        label.backgroundColor = .white
        label.isAccessibilityElement = true
        label.accessibilityLabel = "Perfect Label"
        label.adjustsFontForContentSizeCategory = true
        
        viewController.view.addSubview(label)
        
        let report = A11yReporter.generateReport(for: viewController)
        
        XCTAssertTrue(report.contains("Total issues found: 0"))
    }
    
    func testReportContainsViewHierarchy() {
        let containerView = UIView()
        let nestedLabel = UILabel()
        nestedLabel.text = "Nested Label"
        
        containerView.addSubview(nestedLabel)
        viewController.view.addSubview(containerView)
        
        let report = A11yReporter.generateReport(for: viewController)
        
        XCTAssertTrue(report.contains("UIView"))
        XCTAssertTrue(report.contains("  UILabel"))  // Indented to show hierarchy
    }
}
