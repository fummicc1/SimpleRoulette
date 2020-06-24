//
//  Package.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/06/24.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

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
            path: "SimpleRoulette/Source"),
    ]
)
