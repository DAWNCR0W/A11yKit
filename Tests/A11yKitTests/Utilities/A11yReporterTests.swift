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
    var testView: UIView!

    override func setUpWithError() throws {
        viewController = UIViewController()
        testView = UIView()
        viewController.view.addSubview(testView)
    }

    func testGenerateReport() throws {
        let report = A11yReporter.generateReport(for: viewController)
        XCTAssertTrue(report.contains("A11yKit Accessibility Report"))
        XCTAssertTrue(report.contains("Total issues found"))
    }

    func testReportHasVoiceOverIssues() throws {
        testView.isAccessibilityElement = true
        testView.accessibilityLabel = nil
        let report = A11yReporter.generateReport(for: viewController)
        XCTAssertTrue(report.contains("VoiceOver issues"))
        XCTAssertTrue(report.contains("Missing accessibility label"))
    }

    func testReportHasNoIssues() throws {
        testView.isAccessibilityElement = true
        testView.accessibilityLabel = "Test View"
        let report = A11yReporter.generateReport(for: viewController)
        XCTAssertTrue(report.contains("- Total issues found: 0"))
    }

    func testReportHasDynamicTypeIssues() throws {
        let label = UILabel()
        viewController.view.addSubview(label)
        label.adjustsFontForContentSizeCategory = false
        let report = A11yReporter.generateReport(for: viewController)
        XCTAssertTrue(report.contains("Dynamic Type issues"))
        XCTAssertTrue(report.contains("Label not adjusted for Dynamic Type"))
    }

    func testReportHasColorContrastIssues() throws {
        let label = UILabel()
        label.textColor = .lightGray
        label.backgroundColor = .white
        viewController.view.addSubview(label)
        let report = A11yReporter.generateReport(for: viewController)
        XCTAssertTrue(report.contains("Color Contrast issues"))
    }
}
