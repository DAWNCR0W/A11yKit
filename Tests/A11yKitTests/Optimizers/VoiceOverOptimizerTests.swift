//
//  VoiceOverOptimizerTests.swift
//  A11yKitTests
//
//  Created by dawncr0w on 10/21/24.
//

import XCTest
@testable import A11yKit

class VoiceOverOptimizerTests: XCTestCase {
    
    var viewController: UIViewController!
    var label: UILabel!
    var button: UIButton!
    var textField: UITextField!
    var imageView: UIImageView!
    var textView: UITextView!
    var segmentedControl: UISegmentedControl!
    var switchControl: UISwitch!
    var slider: UISlider!

    override func setUpWithError() throws {
        viewController = UIViewController()
        
        label = UILabel()
        label.text = "Label Text"
        
        button = UIButton()
        button.setTitle("Button Title", for: .normal)
        
        textField = UITextField()
        textField.placeholder = "Enter text"
        
        imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        
        textView = UITextView()
        textView.text = "Sample TextView"
        
        segmentedControl = UISegmentedControl(items: ["First", "Second"])
        
        switchControl = UISwitch()
        
        slider = UISlider()

        viewController.view.addSubview(label)
        viewController.view.addSubview(button)
        viewController.view.addSubview(textField)
        viewController.view.addSubview(imageView)
        viewController.view.addSubview(textView)
        viewController.view.addSubview(segmentedControl)
        viewController.view.addSubview(switchControl)
        viewController.view.addSubview(slider)
    }

    func testLabelOptimization() throws {
        let optimizer = VoiceOverOptimizer()
        optimizer.optimize(label)
        XCTAssertEqual(label.accessibilityLabel, "Label Text")
        XCTAssertTrue(label.accessibilityTraits.contains(.staticText))
    }

    func testButtonOptimization() throws {
        let optimizer = VoiceOverOptimizer()
        optimizer.optimize(button)
        XCTAssertEqual(button.accessibilityLabel, "Button Title")
        XCTAssertTrue(button.accessibilityTraits.contains(.button))
    }

    func testTextFieldOptimization() throws {
        let optimizer = VoiceOverOptimizer()
        optimizer.optimize(textField)
        XCTAssertEqual(textField.accessibilityLabel, "Enter text")
        XCTAssertTrue(textField.accessibilityTraits.contains(.searchField))
    }

    func testImageViewOptimization() throws {
        let optimizer = VoiceOverOptimizer()
        optimizer.optimize(imageView)
        XCTAssertEqual(imageView.accessibilityLabel, "Image")
        XCTAssertTrue(imageView.accessibilityTraits.contains(.image))
        XCTAssertTrue(imageView.accessibilityTraits.contains(.button))
    }

    func testTextViewOptimization() throws {
        let optimizer = VoiceOverOptimizer()
        optimizer.optimize(textView)
        XCTAssertEqual(textView.accessibilityLabel, "Sample TextView")
        XCTAssertTrue(textView.accessibilityTraits.contains(.staticText))
    }

    func testSegmentedControlOptimization() throws {
        let optimizer = VoiceOverOptimizer()
        optimizer.optimize(segmentedControl)
        XCTAssertEqual(segmentedControl.accessibilityLabel, "Segmented Control")
        XCTAssertTrue(segmentedControl.accessibilityTraits.contains(.adjustable))
    }

    func testSwitchOptimization() throws {
        let optimizer = VoiceOverOptimizer()
        optimizer.optimize(switchControl)
        XCTAssertEqual(switchControl.accessibilityLabel, "Switch")
        XCTAssertTrue(switchControl.accessibilityTraits.contains(.button))
    }

    func testSliderOptimization() throws {
        let optimizer = VoiceOverOptimizer()
        optimizer.optimize(slider)
        XCTAssertEqual(slider.accessibilityLabel, "Slider")
        XCTAssertTrue(slider.accessibilityTraits.contains(.adjustable))
    }
}
