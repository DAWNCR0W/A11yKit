//
//  A11yKitTests.swift
//  A11yKitTests
//
//  Created by dawncr0w on 10/21/24.
//

import XCTest
@testable import A11yKit

class A11yKitTests: XCTestCase {

    var a11yKit: A11yKit!
    var viewController: UIViewController!
    var testView: UIView!

    override func setUpWithError() throws {
        a11yKit = A11yKit.shared
        viewController = UIViewController()
        testView = UIView()
        viewController.view.addSubview(testView)
    }

    func testConfigurationUpdate() throws {
        var config = A11yConfiguration()
        config.minimumContrastRatio = 7.0
        a11yKit.updateConfiguration(config)
        
        XCTAssertEqual(a11yKit.configuration.minimumContrastRatio, 7.0)
    }

    func testLoggingEnabled() throws {
        a11yKit.setLoggingEnabled(true)
        XCTAssertTrue(a11yKit.isLoggingEnabled)
        
        a11yKit.setLoggingEnabled(false)
        XCTAssertFalse(a11yKit.isLoggingEnabled)
    }

    func testMinimumContrastRatioUpdate() throws {
        a11yKit.setMinimumContrastRatio(5.0)
        XCTAssertEqual(a11yKit.configuration.minimumContrastRatio, 5.0)
    }

    func testPreferredContentSizeCategoryUpdate() throws {
        a11yKit.setPreferredContentSizeCategory(.large)
        XCTAssertEqual(a11yKit.configuration.preferredContentSizeCategory, .large)
    }

    func testOptimizeView() throws {
        let options: OptimizationOptions = .all
        a11yKit.optimize(testView, options: options)
        XCTAssertTrue(testView.isAccessibilityElement)
    }

    func testUndoLastOptimization() throws {
        let button = UIButton()
        viewController.view.addSubview(button)
        a11yKit.optimize(button, options: .dynamicType)
        
        XCTAssertTrue(button.titleLabel?.adjustsFontForContentSizeCategory ?? false)

        a11yKit.undoLastOptimization()
        XCTAssertFalse(button.isAccessibilityElement)
    }

    func testAccessibilityReportGeneration() throws {
        let report = a11yKit.generateAccessibilityReport(for: viewController)
        XCTAssertTrue(report.contains("Accessibility Report"))
    }

    func testPerformAudit() throws {
        let issues = a11yKit.performAccessibilityAudit(on: viewController)
        XCTAssertTrue(issues.isEmpty)
    }
}
