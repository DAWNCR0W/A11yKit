// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "A11yKit",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "A11yKit",
            targets: ["A11yKit"]),
        .library(
            name: "A11yKitDynamic",
            type: .dynamic,
            targets: ["A11yKit"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "A11yKit"),
        .testTarget(
            name: "A11yKitTests",
            dependencies: ["A11yKit"]
        ),
    ]
)
