//
//  UIColorContrastTests.swift
//  A11yKitTests
//
//  Created by dawncr0w on 10/21/24.
//

import XCTest
import UIKit

class UIColorContrastTests: XCTestCase {
    
    var color: UIColor!
    var backgroundColor: UIColor!

    override func setUpWithError() throws {
        color = UIColor.white
        backgroundColor = UIColor.black
    }

    func testContrastRatio() throws {
        let contrastRatio = color.contrastRatio(with: backgroundColor)
        XCTAssertEqual(contrastRatio, 21.0, accuracy: 0.001)
    }

    func testLuminanceCalculationForWhite() throws {
        let whiteLuminance = UIColor.white.luminance()
        XCTAssertEqual(whiteLuminance, 1.0, accuracy: 0.001)
    }

    func testLuminanceCalculationForBlack() throws {
        let blackLuminance = UIColor.black.luminance()
        XCTAssertEqual(blackLuminance, 0.0, accuracy: 0.001)
    }

    func testAdjustedForContrast_Lighten() throws {
        let lowContrastColor = UIColor.gray
        let adjustedColor = lowContrastColor.adjustedForContrast(against: backgroundColor, targetContrast: 4.5)
        
        let adjustedContrast = adjustedColor.contrastRatio(with: backgroundColor)
        XCTAssertGreaterThanOrEqual(adjustedContrast, 4.5)
    }

    func testAdjustedForContrast_Darken() throws {
        let lowContrastBackground = UIColor.white
        let adjustedColor = color.adjustedForContrast(against: lowContrastBackground, targetContrast: 7.0)
        
        let adjustedContrast = adjustedColor.contrastRatio(with: lowContrastBackground)
        XCTAssertGreaterThanOrEqual(adjustedContrast, 7.0)
    }

    func testMeetsMinimumContrast() throws {
        let meetsContrast = color.meetsMinimumContrast(4.5, against: backgroundColor)
        XCTAssertTrue(meetsContrast)
    }

    func testDoesNotMeetMinimumContrast() throws {
        let lowContrastColor = UIColor.lightGray
        let meetsContrast = lowContrastColor.meetsMinimumContrast(7.0, against: backgroundColor)
        XCTAssertFalse(meetsContrast)
    }
}
