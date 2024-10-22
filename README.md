# A11yKit

A11yKit is a powerful and easy-to-use Swift library for automating accessibility improvements in iOS applications. It
helps developers create more inclusive apps by automatically optimizing UI elements for VoiceOver, Dynamic Type, and
color contrast.

## Features

- Automatic optimization for VoiceOver accessibility
- Dynamic Type support for better text readability
- Color contrast enhancement for improved visibility
- Customizable optimization options
- Accessibility auditing and report generation
- Logging system for tracking optimizations
- Undo functionality for optimization actions
- Asynchronous optimization support
- Intelligent filtering of UI elements for optimization

## Accessibility Standards

A11yKit helps your app comply with the following accessibility standards:

- WCAG 2.1 (Web Content Accessibility Guidelines)
  - Supports up to AAA level for color contrast
- iOS Accessibility Best Practices
- Section 508 of the Rehabilitation Act

## Requirements

- iOS 13.0+
- Swift 5.3+
- Xcode 12.0+

## Installation

### Swift Package Manager

You can install A11yKit using the [Swift Package Manager](https://swift.org/package-manager/). Add the following to your
`Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/DAWNCR0W/A11yKit.git", from: "0.1.2")
]
```

## Usage

### Basic Usage

```swift
import A11yKit

class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Optimize all views in the view controller
        A11yKit.shared.optimizeAll(self)
    }
}
```

### Advanced Usage

```swift
import A11yKit

class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let a11y = A11yKit.shared
        
        // Configure A11yKit
        a11y.setLoggingEnabled(true)
        
        var config = A11yConfiguration()
        config.minimumContrastRatio = 7.0 // WCAG AAA standard
        config.preferredContentSizeCategory = .large
        config.enableVoiceOverOptimization = true
        config.enableDynamicType = true
        config.enableColorContrastOptimization = true
        config.autoGenerateVoiceOverLabels = true
        a11y.updateConfiguration(config)
        
        // Optimize with specific options
        a11y.optimizeAll(self, options: [.voiceOver, .dynamicType, .colorContrast])
        
        // Optimize a specific view
        if let specialView = view.viewWithTag(100) {
            a11y.optimize(specialView, options: .colorContrast)
        }
        
        // Generate an accessibility report
        let report = a11y.generateAccessibilityReport(for: self)
        print(report)
        
        // Perform an accessibility audit
        let issues = a11y.auditAll(self)
        print("Found \(issues.count) accessibility issues")
        
        // Undo last optimization
        a11y.undoLastOptimization()
        
        // Get diagnostic information
        let diagnosticInfo = a11y.getDiagnosticInfo()
        print(diagnosticInfo)
        
        // Exclude specific views or view classes from optimization
        a11y.excludeViewFromOptimization(someInternalView)
        a11y.excludeViewClassFromOptimization(UIVisualEffectView.self)
        
        // Add custom class prefix to auto-exclude list
        a11y.addAutoExcludedClassPrefix("MyApp_Internal")
    }
    
    func optimizeAsync() async {
        await A11yKit.shared.optimizeAsync(view)
    }
}
```

### Customization

A11yKit provides several customization options through A11yConfiguration:

- `isEnabled`: Enable or disable A11yKit
- `logLevel`: Set the logging level
- `autoGenerateVoiceOverLabels`: Automatically generate VoiceOver labels
- `enableDynamicType`: Enable or disable Dynamic Type optimizations
- `enableColorContrastOptimization`: Enable or disable color contrast optimizations
- `minimumContrastRatio`: Set the minimum contrast ratio for color optimizations
- `preferredContrastRatio`: Set the preferred contrast ratio for color optimizations
- `excludedViewTags`: Set of view tags to exclude from optimization
- `excludedViewClasses`: Set of view classes to exclude from optimization
- `minimumViewSize`: Minimum size for views to be considered for optimization
- `autoExcludedClassPrefixes`: Set of class name prefixes to automatically exclude from optimization

## APIReference

### A11yKit

The main class that provides accessibility optimization methods.

#### Methods

- `optimize(_:options:)`: Optimize a single view with specified options
- `optimizeAll(_:options:)`: Optimize all views in a view controller
- `optimizeVoiceOver(for:)`: Optimize a view for VoiceOver
- `optimizeDynamicType(for:)`: Optimize a view for Dynamic Type
- `optimizeColorContrast(for:)`: Optimize a view's color contrast
- `resetAccessibilityProperties(for:)`: Reset accessibility properties for a view
- `generateAccessibilityReport(for:)`: Generate an accessibility report for a view controller
- `performAccessibilityAudit(on:)`: Perform an accessibility audit on a view controller
- `updateConfiguration(_:)`: Update the A11yKit configuration
- `setLoggingEnabled(_:)`: Enable or disable logging
- `setMinimumContrastRatio(_:)`: Set the minimum contrast ratio
- `setPreferredContentSizeCategory(_:)`: Set the preferred content size category
- `undoLastOptimization()`: Undo the last optimization action
- `optimizeAsync(_:options:)`: Asynchronously optimize a view
- `excludeViewFromOptimization(_:)`: Exclude a specific view from optimization
- `excludeViewClassFromOptimization(_:)`: Exclude a specific view class from optimization
- `addAutoExcludedClassPrefix(_:)`: Add a class name prefix to the auto-exclude list
- `removeAutoExcludedClassPrefix(_:)`: Remove a class name prefix from the auto-exclude list

### OptimizationOptions

An option set that specifies which optimizations to apply.

- `.voiceOver`: Optimize for VoiceOver
- `.dynamicType`: Optimize for Dynamic Type
- `.colorContrast`: Optimize color contrast
- `.all`: Apply all optimizations

## Contributing

Contributions to A11yKit are welcome! Please feel free to submit a Pull Request.

## License

A11yKit is released under the MIT license. See [LICENSE](LICENSE) for more information.
