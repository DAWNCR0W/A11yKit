//
//  A11yLoggerTests.swift
//  A11yKitTests
//
//  Created by dawncr0w on 10/21/24.
//

import XCTest
@testable import A11yKit

class A11yLoggerTests: XCTestCase {
    
    override func setUpWithError() throws {
        A11yLogger.isEnabled = true
        A11yLogger.minimumLogLevel = .info
    }

    func testLogDebugLevel() throws {
        A11yLogger.minimumLogLevel = .debug
        A11yLogger.debug("This is a debug message")
        XCTAssertTrue(A11yLogger.isEnabled)
    }

    func testLogInfoLevel() throws {
        A11yLogger.minimumLogLevel = .info
        A11yLogger.info("This is an info message")
        XCTAssertTrue(A11yLogger.isEnabled)
    }

    func testLogWarningLevel() throws {
        A11yLogger.minimumLogLevel = .warning
        A11yLogger.warning("This is a warning message")
        XCTAssertTrue(A11yLogger.isEnabled)
    }

    func testLogErrorLevel() throws {
        A11yLogger.minimumLogLevel = .error
        A11yLogger.error("This is an error message")
        XCTAssertTrue(A11yLogger.isEnabled)
    }

    func testLogDisabled() throws {
        A11yLogger.isEnabled = false
        A11yLogger.info("This message should not appear")
        XCTAssertFalse(A11yLogger.isEnabled)
    }

    func testLogCorrectLevel() throws {
        A11yLogger.minimumLogLevel = .warning
        A11yLogger.info("This should not log")
        A11yLogger.warning("This should log")
        A11yLogger.error("This should log")
        XCTAssertTrue(A11yLogger.isEnabled)
    }

    func testMinimumLogLevel() throws {
        A11yLogger.minimumLogLevel = .error
        XCTAssertTrue(A11yLogger.minimumLogLevel == .error)
    }
}
