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
    
    override func setUp() {
        super.setUp()
        label = UILabel()
        label.text = "Test Label"
    }
    
    override func tearDown() {
        label = nil
        super.tearDown()
    }
    
    func testA11yOptimizeForDynamicType() {
        label.a11y_optimizeForDynamicType()
        
        XCTAssertTrue(label.adjustsFontForContentSizeCategory)
        XCTAssertNotNil(label.font.fontDescriptor.object(forKey: .textStyle))
    }
    
    func testA11ySetAccessibleFont() {
        label.a11y_setAccessibleFont(style: .headline)
        
        XCTAssertTrue(label.adjustsFontForContentSizeCategory)
        XCTAssertEqual(label.font, UIFont.preferredFont(forTextStyle: .headline))
    }
    
    func testA11yOptimizeContrast() {
        label.textColor = .lightGray
        label.backgroundColor = .white
        
        label.a11y_optimizeContrast(against: .white)
        
        XCTAssertGreaterThanOrEqual(label.textColor.contrastRatio(with: .white), A11yKit.shared.configuration.minimumContrastRatio)
    }
    
    func testA11yMakeAccessible() {
        label.a11y_makeAccessible(prefix: "Important: ", suffix: " (Required)")
        
        XCTAssertTrue(label.isAccessibilityElement)
        XCTAssertEqual(label.accessibilityLabel, "Important: Test Label (Required)")
    }
}
