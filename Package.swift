// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "SimpleRoulette",
    platforms: [
        .iOS(.v17), .macOS(.v14)
    ],
    products: [
        .library(
            name: "SimpleRoulette",
            targets: ["SimpleRoulette"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"
        ),
    ],
    targets: [
        .target(
            name: "SimpleRoulette",
            dependencies: [],
            exclude: ["Info.plist"],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "SimpleRouletteTests",
            dependencies: ["SimpleRoulette"]
        )
    ]
)
