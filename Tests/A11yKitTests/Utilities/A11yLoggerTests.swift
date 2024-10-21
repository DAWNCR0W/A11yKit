//
//  A11yLoggerTests.swift
//  A11yKitTests
//
//  Created by dawncr0w on 10/21/24.
//

import Foundation
import XCTest
@testable import A11yKit

class A11yLoggerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        A11yLogger.isEnabled = true
        A11yLogger.minimumLogLevel = .debug
    }
    
    override func tearDown() {
        A11yLogger.isEnabled = false
        super.tearDown()
    }
    
    func testLogLevels() {
        let expectation = self.expectation(description: "Log message")
        expectation.expectedFulfillmentCount = 4
        
        let output = captureConsoleOutput {
            A11yLogger.debug("Debug message")
            A11yLogger.info("Info message")
            A11yLogger.warning("Warning message")
            A11yLogger.error("Error message")
        }
        
        XCTAssertTrue(output.contains("🟣 A11yKit [debug]"))
        XCTAssertTrue(output.contains("🔵 A11yKit [info]"))
        XCTAssertTrue(output.contains("🟠 A11yKit [warning]"))
        XCTAssertTrue(output.contains("🔴 A11yKit [error]"))
        
        expectation.fulfill()
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLoggerDisabled() {
        A11yLogger.isEnabled = false
        
        let output = captureConsoleOutput {
            A11yLogger.info("This should not be logged")
        }
        
        XCTAssertTrue(output.isEmpty)
    }
    
    func testMinimumLogLevel() {
        A11yLogger.minimumLogLevel = .warning
        
        let output = captureConsoleOutput {
            A11yLogger.debug("Debug message")
            A11yLogger.info("Info message")
            A11yLogger.warning("Warning message")
            A11yLogger.error("Error message")
        }
        
        XCTAssertFalse(output.contains("Debug message"))
        XCTAssertFalse(output.contains("Info message"))
        XCTAssertTrue(output.contains("Warning message"))
        XCTAssertTrue(output.contains("Error message"))
    }
    
    // Helper function to capture console output
    func captureConsoleOutput(_ block: () -> Void) -> String {
        let pipe = Pipe()
        let pipeOutput = pipe.fileHandleForReading
        
        let oldStdout = dup(STDOUT_FILENO)
        dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
        
        block()
        
        fflush(stdout)
        pipe.fileHandleForWriting.closeFile()
        
        let data = pipeOutput.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8) ?? ""
        
        dup2(oldStdout, STDOUT_FILENO)
        close(oldStdout)
        
        return output
    }
}
