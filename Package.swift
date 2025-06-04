// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ViewComponents",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ViewComponents",
            targets: ["ViewComponents"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/leviouwendijk/plate.git",
            branch: "master"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ViewComponents",
            dependencies: [
                .product(name: "plate", package: "plate")
            ]
        ),
        .testTarget(
            name: "ViewComponentsTests",
            dependencies: [
                "ViewComponents",
                .product(name: "plate", package: "plate")
            ]
        ),
    ]
)
