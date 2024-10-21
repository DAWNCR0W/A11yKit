//
//  UIColorContrastTests.swift
//  A11yKitTests
//
//  Created by dawncr0w on 10/21/24.
//

import XCTest
@testable import A11yKit

class UIColorContrastTests: XCTestCase {
    
    func testContrastRatio() {
        let whiteColor = UIColor.white
        let blackColor = UIColor.black
        let grayColor = UIColor.gray
        
        XCTAssertEqual(whiteColor.contrastRatio(with: blackColor), 21.0, accuracy: 0.1)
        XCTAssertEqual(whiteColor.contrastRatio(with: grayColor), 3.95, accuracy: 0.1)
        XCTAssertEqual(blackColor.contrastRatio(with: grayColor), 5.31, accuracy: 0.1)
    }
    
    func testLuminance() {
        XCTAssertEqual(UIColor.white.luminance(), 1.0, accuracy: 0.01)
        XCTAssertEqual(UIColor.black.luminance(), 0.0, accuracy: 0.01)
        XCTAssertEqual(UIColor.gray.luminance(), 0.2158, accuracy: 0.01)
    }
    
    func testAdjustedForContrast() {
        let lightGray = UIColor.lightGray
        let white = UIColor.white
        let targetContrast: CGFloat = 4.5
        
        let adjustedColor = lightGray.adjustedForContrast(against: white, targetContrast: targetContrast)
        
        XCTAssertGreaterThanOrEqual(adjustedColor.contrastRatio(with: white), targetContrast)
    }
    
    func testMeetsMinimumContrast() {
        let blackColor = UIColor.black
        let whiteColor = UIColor.white
        let grayColor = UIColor.gray
        
        XCTAssertTrue(blackColor.meetsMinimumContrast(4.5, against: whiteColor))
        XCTAssertFalse(grayColor.meetsMinimumContrast(4.5, against: whiteColor))
        XCTAssertTrue(grayColor.meetsMinimumContrast(3.0, against: whiteColor))
    }
    
    func testContrastRatioEdgeCases() {
        let sameColor = UIColor.red
        XCTAssertEqual(sameColor.contrastRatio(with: sameColor), 1.0, accuracy: 0.01)
        
        let transparentColor = UIColor.clear
        XCTAssertEqual(UIColor.black.contrastRatio(with: transparentColor), 1.0, accuracy: 0.01)
    }
}
