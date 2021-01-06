// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftSWOT",
    platforms: [
        .macOS(.v10_15),
        .iOS("14.0")
    ],
    products: [
        .library(
            name: "SwiftSWOT",
            targets: ["SwiftSWOT"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftSWOT",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
            ],
            resources: [
                .copy("Resources")
            ]
            version: "1.0.0"),
        .testTarget(
            name: "SwiftSWOTTests",
            dependencies: ["SwiftSWOT"]),
    ]
)
