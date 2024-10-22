//
//  ColorContrastOptimizerTests.swift
//  A11yKitTests
//
//  Created by dawncr0w on 10/21/24.
//

import XCTest
@testable import A11yKit

class ColorContrastOptimizerTests: XCTestCase {

    var label: UILabel!
    var button: UIButton!
    var textField: UITextField!
    var textView: UITextView!
    var segmentedControl: UISegmentedControl!
    var searchBar: UISearchBar!
    var optimizer: ColorContrastOptimizer!
    var configuration: A11yConfiguration!

    override func setUpWithError() throws {
        optimizer = ColorContrastOptimizer()
        configuration = A11yConfiguration()
        
        label = UILabel()
        button = UIButton()
        textField = UITextField()
        textView = UITextView()
        segmentedControl = UISegmentedControl(items: ["One", "Two"])
        searchBar = UISearchBar()

        label.textColor = .gray
        label.backgroundColor = .white

        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .white

        textField.textColor = .gray
        textField.backgroundColor = .white

        textView.textColor = .gray
        textView.backgroundColor = .white

        searchBar.searchTextField.textColor = .gray
        searchBar.searchTextField.backgroundColor = .white
    }

    func testOptimizeLabelContrast() throws {
        optimizer.optimize(label, with: configuration)
        let contrastRatio = label.textColor.contrastRatio(with: label.backgroundColor ?? .white)
        XCTAssertGreaterThanOrEqual(contrastRatio, configuration.minimumContrastRatio)
    }

    func testOptimizeButtonContrast() throws {
        optimizer.optimize(button, with: configuration)
        let titleColor = button.titleColor(for: .normal)
        let contrastRatio = titleColor?.contrastRatio(with: button.backgroundColor ?? .white)
        XCTAssertGreaterThanOrEqual(contrastRatio ?? 0, configuration.minimumContrastRatio)
    }

    func testOptimizeTextFieldContrast() throws {
        optimizer.optimize(textField, with: configuration)
        let contrastRatio = textField.textColor?.contrastRatio(with: textField.backgroundColor ?? .white)
        XCTAssertGreaterThanOrEqual(contrastRatio ?? 0, configuration.minimumContrastRatio)
    }

    func testOptimizeTextViewContrast() throws {
        optimizer.optimize(textView, with: configuration)
        let contrastRatio = textView.textColor?.contrastRatio(with: textView.backgroundColor ?? .white)
        XCTAssertGreaterThanOrEqual(contrastRatio ?? 0, configuration.minimumContrastRatio)
    }

    func testOptimizeSegmentedControlContrast() throws {
        optimizer.optimize(segmentedControl, with: configuration)
        for state in [UIControl.State.normal, .selected] {
            let attributes = segmentedControl.titleTextAttributes(for: state)
            let textColor = attributes?[.foregroundColor] as? UIColor
            let contrastRatio = textColor?.contrastRatio(with: segmentedControl.backgroundColor ?? .white)
            XCTAssertGreaterThanOrEqual(contrastRatio ?? 0, configuration.minimumContrastRatio)
        }
    }

    func testOptimizeSearchBarContrast() throws {
        optimizer.optimize(searchBar, with: configuration)
        let textColor = searchBar.searchTextField.textColor
        let contrastRatio = textColor?.contrastRatio(with: searchBar.searchTextField.backgroundColor ?? .white)
        XCTAssertGreaterThanOrEqual(contrastRatio ?? 0, configuration.minimumContrastRatio)
    }
}
