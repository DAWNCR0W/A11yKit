//
//  DynamicTypeOptimizer.swift
//  A11yKit
//
//  Created by dawncr0w on 10/21/24.
//

import UIKit

@MainActor
class DynamicTypeOptimizer: @preconcurrency Optimizer {
    
    // MARK: - Properties
    
    private let defaultTextStyle: UIFont.TextStyle = .body
    
    // MARK: - Optimizer Protocol
    
    func optimize(_ view: UIView, with configuration: A11yConfiguration) {
        optimizeView(view, with: configuration)
        
        for subview in view.subviews {
            optimize(subview, with: configuration)
        }
    }
    
    // MARK: - Private Methods
    
    private func optimizeView(_ view: UIView, with configuration: A11yConfiguration) {
        switch view {
        case let label as UILabel:
            optimizeLabel(label, with: configuration)
        case let button as UIButton:
            optimizeButton(button, with: configuration)
        case let textField as UITextField:
            optimizeTextField(textField, with: configuration)
        case let textView as UITextView:
            optimizeTextView(textView, with: configuration)
        case let segmentedControl as UISegmentedControl:
            optimizeSegmentedControl(segmentedControl, with: configuration)
        case let tableView as UITableView:
            optimizeTableView(tableView, with: configuration)
        case let collectionView as UICollectionView:
            optimizeCollectionView(collectionView, with: configuration)
        case let searchBar as UISearchBar:
            optimizeSearchBar(searchBar, with: configuration)
        default:
            optimizeGenericView(view, with: configuration)
        }
    }
    
    private func optimizeLabel(_ label: UILabel, with configuration: A11yConfiguration) {
        label.adjustsFontForContentSizeCategory = true
        label.font = scaledFont(for: label.font, textStyle: .body)
        
        if configuration.enableLargeContentViewer {
            label.showsLargeContentViewer = true
        }
    }
    
    private func optimizeButton(_ button: UIButton, with configuration: A11yConfiguration) {
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        if let titleFont = button.titleLabel?.font {
            button.titleLabel?.font = scaledFont(for: titleFont, textStyle: .body)
        }
        
        if configuration.enableLargeContentViewer {
            button.showsLargeContentViewer = true
        }
    }
    
    private func optimizeTextField(_ textField: UITextField, with configuration: A11yConfiguration) {
        textField.adjustsFontForContentSizeCategory = true
        textField.font = scaledFont(for: textField.font, textStyle: .body)
        
        if configuration.enableLargeContentViewer {
            textField.showsLargeContentViewer = true
        }
    }
    
    private func optimizeTextView(_ textView: UITextView, with configuration: A11yConfiguration) {
        textView.adjustsFontForContentSizeCategory = true
        textView.font = scaledFont(for: textView.font, textStyle: .body)
        
        if configuration.enableLargeContentViewer {
            textView.showsLargeContentViewer = true
        }
    }
    
    private func optimizeSegmentedControl(_ segmentedControl: UISegmentedControl, with configuration: A11yConfiguration) {
        let defaultAttributes = segmentedControl.titleTextAttributes(for: .normal) ?? [:]
        let selectedAttributes = segmentedControl.titleTextAttributes(for: .selected) ?? [:]
        
        if let font = defaultAttributes[.font] as? UIFont {
            let scaledFont = scaledFont(for: font, textStyle: .body)
            segmentedControl.setTitleTextAttributes([.font: scaledFont], for: .normal)
        }
        
        if let font = selectedAttributes[.font] as? UIFont {
            let scaledFont = scaledFont(for: font, textStyle: .body)
            segmentedControl.setTitleTextAttributes([.font: scaledFont], for: .selected)
        }
        
        if configuration.enableLargeContentViewer {
            segmentedControl.showsLargeContentViewer = true
        }
    }
    
    private func optimizeTableView(_ tableView: UITableView, with configuration: A11yConfiguration) {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        
        if configuration.enableLargeContentViewer {
            tableView.showsLargeContentViewer = true
        }
    }
    
    private func optimizeCollectionView(_ collectionView: UICollectionView, with configuration: A11yConfiguration) {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        if configuration.enableLargeContentViewer {
            collectionView.showsLargeContentViewer = true
        }
    }
    
    private func optimizeSearchBar(_ searchBar: UISearchBar, with configuration: A11yConfiguration) {
        searchBar.searchTextField.adjustsFontForContentSizeCategory = true
        searchBar.searchTextField.font = scaledFont(for: searchBar.searchTextField.font, textStyle: .body)
        
        if configuration.enableLargeContentViewer {
            searchBar.showsLargeContentViewer = true
        }
    }
    
    private func optimizeGenericView(_ view: UIView, with configuration: A11yConfiguration) {
        if configuration.enableLargeContentViewer {
            view.showsLargeContentViewer = true
        }
    }
    
    private func scaledFont(for font: UIFont?, textStyle: UIFont.TextStyle) -> UIFont {
        guard let font = font else {
            return UIFont.preferredFont(forTextStyle: textStyle)
        }
        
        let metrics = UIFontMetrics(forTextStyle: textStyle)
        return metrics.scaledFont(for: font)
    }
}
