// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "SimpleRoulette",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SimpleRoulette",
            targets: ["SimpleRoulette"]),
    ],
    targets: [
        .target(
            name: "SimpleRoulette",
            dependencies: [],
            path: "SimpleRoulette/Sources"),
    ]
)
