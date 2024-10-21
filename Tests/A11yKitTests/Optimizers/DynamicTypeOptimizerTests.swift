//
//  DynamicTypeOptimizerTests.swift
//  A11yKitTests
//
//  Created by dawncr0w on 10/21/24.
//

import XCTest
@testable import A11yKit

class DynamicTypeOptimizerTests: XCTestCase {
    
    var optimizer: DynamicTypeOptimizer!
    var configuration: A11yConfiguration!
    
    override func setUp() {
        super.setUp()
        optimizer = DynamicTypeOptimizer()
        configuration = A11yConfiguration()
    }
    
    override func tearDown() {
        optimizer = nil
        configuration = nil
        super.tearDown()
    }
    
    func testOptimizeLabel() {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        
        optimizer.optimize(label, with: configuration)
        
        XCTAssertTrue(label.adjustsFontForContentSizeCategory)
        XCTAssertNotNil(label.font.fontDescriptor.object(forKey: .textStyle))
    }
    
    func testOptimizeButton() {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        optimizer.optimize(button, with: configuration)
        
        XCTAssertTrue(button.titleLabel?.adjustsFontForContentSizeCategory ?? false)
        XCTAssertNotNil(button.titleLabel?.font.fontDescriptor.object(forKey: .textStyle))
    }
    
    func testOptimizeTextField() {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        
        optimizer.optimize(textField, with: configuration)
        
        XCTAssertTrue(textField.adjustsFontForContentSizeCategory)
        XCTAssertNotNil(textField.font?.fontDescriptor.object(forKey: .textStyle))
    }
    
    func testLargeContentViewerEnabled() {
        configuration.enableLargeContentViewer = true
        let button = UIButton()
        
        optimizer.optimize(button, with: configuration)
        
        XCTAssertTrue(button.showsLargeContentViewer)
    }
    
    func testAuditWithIssues() {
        let view = UIView()
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontForContentSizeCategory = false
        view.addSubview(label)
        
        let issues = optimizer.audit(view, with: configuration)
        
        XCTAssertFalse(issues.isEmpty)
        XCTAssertEqual(issues.first?.issueType, .dynamicType)
        XCTAssertTrue(issues.first?.description.contains("not adjusted for Dynamic Type") ?? false)
    }
    
    func testAuditWithoutIssues() {
        let view = UIView()
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        view.addSubview(label)
        
        let issues = optimizer.audit(view, with: configuration)
        
        XCTAssertTrue(issues.isEmpty)
    }
}
