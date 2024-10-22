//
//  DynamicTypeOptimizerTests.swift
//  A11yKitTests
//
//  Created by dawncr0w on 10/21/24.
//

import XCTest
@testable import A11yKit

class DynamicTypeOptimizerTests: XCTestCase {
    
    var label: UILabel!
    var button: UIButton!
    var textField: UITextField!
    var textView: UITextView!
    var segmentedControl: UISegmentedControl!
    var tableView: UITableView!
    var collectionView: UICollectionView!
    var searchBar: UISearchBar!
    var optimizer: DynamicTypeOptimizer!

    override func setUpWithError() throws {
        optimizer = DynamicTypeOptimizer()

        label = UILabel()
        button = UIButton()
        textField = UITextField()
        textView = UITextView()
        segmentedControl = UISegmentedControl(items: ["First", "Second"])
        tableView = UITableView()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        searchBar = UISearchBar()
    }

    func testLabelOptimization() throws {
        optimizer.optimize(label, with: A11yKit.shared.configuration)
        XCTAssertTrue(label.adjustsFontForContentSizeCategory)
    }

    func testButtonOptimization() throws {
        optimizer.optimize(button, with: A11yKit.shared.configuration)
        XCTAssertTrue(button.titleLabel?.adjustsFontForContentSizeCategory ?? false)
    }

    func testTextFieldOptimization() throws {
        optimizer.optimize(textField, with: A11yKit.shared.configuration)
        XCTAssertTrue(textField.adjustsFontForContentSizeCategory)
    }

    func testTextViewOptimization() throws {
        optimizer.optimize(textView, with: A11yKit.shared.configuration)
        XCTAssertTrue(textView.adjustsFontForContentSizeCategory)
    }

    func testSegmentedControlOptimization() throws {
        optimizer.optimize(segmentedControl, with: A11yKit.shared.configuration)
        for state in [UIControl.State.normal, .selected] {
            let attributes = segmentedControl.titleTextAttributes(for: state)
            let font = attributes?[.font] as? UIFont
            XCTAssertNotNil(font)
            XCTAssertEqual(font, UIFontMetrics.default.scaledFont(for: font ?? UIFont.systemFont(ofSize: 12)))
        }
    }

    func testTableViewOptimization() throws {
        optimizer.optimize(tableView, with: A11yKit.shared.configuration)
        XCTAssertEqual(tableView.rowHeight, UITableView.automaticDimension)
        XCTAssertEqual(tableView.estimatedRowHeight, 44)
    }

    func testCollectionViewOptimization() throws {
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        optimizer.optimize(collectionView, with: A11yKit.shared.configuration)
        XCTAssertEqual(layout?.estimatedItemSize, UICollectionViewFlowLayout.automaticSize)
    }

    func testSearchBarOptimization() throws {
        optimizer.optimize(searchBar, with: A11yKit.shared.configuration)
        XCTAssertTrue(searchBar.searchTextField.adjustsFontForContentSizeCategory)
    }

    func testGenericViewOptimization() throws {
        let genericView = UIView()
        optimizer.optimizeView(genericView, with: A11yKit.shared.configuration)
        XCTAssertTrue(genericView.showsLargeContentViewer)
    }
}
