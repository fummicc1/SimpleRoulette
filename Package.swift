// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "SimpleRoulette",
    platforms: [
        .iOS(.v14), .macOS(.v11)
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
            dependencies: []
        ),
        .testTarget(name: "SimpleRouletteTests", dependencies: ["SimpleRoulette"])
    ]
)
