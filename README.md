# A11yKit

A11yKit is a powerful and easy-to-use Swift library for automating accessibility improvements in iOS applications. It
helps developers create more inclusive apps by automatically optimizing UI elements for VoiceOver, Dynamic Type, and
color contrast.

## Features

- Automatic optimization for VoiceOver accessibility
- Dynamic Type support for better text readability
- Color contrast enhancement for improved visibility
- Customizable optimization options
- Accessibility report generation
- Logging system for tracking optimizations
- Undo functionality for optimization actions
- Asynchronous optimization support

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
    .package(url: "https://github.com/DAWNCR0W/A11yKit.git", from: "0.1.1")
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
        a11y.isLoggingEnabled = true
        a11y.minimumContrastRatio = 7.0 // WCAG AAA standard
        a11y.setPreferredContentSizeCategory(.large)
        
        // Optimize with specific options
        a11y.optimizeAll(self, options: [.voiceOver, .dynamicType])
        
        // Optimize a specific view
        if let specialView = view.viewWithTag(100) {
            a11y.optimizeColorContrast(for: specialView)
        }
        
        // Generate an accessibility report
        let report = a11y.generateAccessibilityReport(for: self)
        print(report)
        
        // Perform an accessibility audit
        let issues = a11y.performAccessibilityAudit(on: self)
        print("Found \(issues.count) accessibility issues")
        
        // Undo last optimization
        a11y.undoLastOptimization()
        
        // Get diagnostic information
        let diagnosticInfo = a11y.getDiagnosticInfo()
        print(diagnosticInfo)
    }
    
    func optimizeAsync() async {
        await A11yKit.shared.optimizeAsync(view)
    }
}
```

### Customization

A11yKit provides several customization options through A11yConfiguration:

- isEnabled: Enable or disable A11yKit
- logLevel: Set the logging level
- autoGenerateVoiceOverLabels: Automatically generate VoiceOver labels
- enableDynamicType: Enable or disable Dynamic Type optimizations
- enableColorContrastOptimization: Enable or disable color contrast optimizations
- minimumContrastRatio: Set the minimum contrast ratio for color optimizations
- preferredContrastRatio: Set the preferred contrast ratio for color optimizations

## APIReference

### A11yKit

The main class that provides accessibility optimization methods.

#### Methods

- optimize(_:options:): Optimize a single view with specified options
- optimizeAll(_:options:): Optimize all views in a view controller
- optimizeVoiceOver(for:): Optimize a view for VoiceOver
- optimizeDynamicType(for:): Optimize a view for Dynamic Type
- optimizeColorContrast(for:): Optimize a view's color contrast
- resetAccessibilityProperties(for:): Reset accessibility properties for a view
- generateAccessibilityReport(for:): Generate an accessibility report for a view controller
- performAccessibilityAudit(on:): Perform an accessibility audit on a view controller
- updateConfiguration(_:): Update the A11yKit configuration
- setLoggingEnabled(_:): Enable or disable logging
- setMinimumContrastRatio(_:): Set the minimum contrast ratio
- setPreferredContentSizeCategory(_:): Set the preferred content size category
- undoLastOptimization(): Undo the last optimization action
- optimizeAsync(_:options:): Asynchronously optimize a view

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
