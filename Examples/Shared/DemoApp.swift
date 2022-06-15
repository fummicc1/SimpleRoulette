//
//  DemoApp.swift
//  Shared
//
//  Created by Fumiya Tanaka on 2022/03/20.
//  Copyright © 2022 Fumiya Tanaka. All rights reserved.
//

import SwiftUI
import SimpleRoulette

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                model: RouletteModel(
                    parts: [
                        PartData(
                            index: 0,
                            content: .label("Swift"),
                            area: .flex(3),
                            fillColor: Color.red
                        ),
                        PartData(
                            index: 1,
                            content: .label("Kotlin"),
                            area: .flex(1),
                            fillColor: Color.purple
                        ),
                        PartData(
                            index: 2,
                            content: .label("JavaScript"),
                            area: .flex(2),
                            fillColor: Color.yellow
                        ),
                        PartData(
                            index: 3,
                            content: .label("Dart"),
                            area: .flex(1),
                            fillColor: Color.green
                        ),
                        PartData(
                            index: 4,
                            content: .label("Python"),
                            area: .flex(2),
                            fillColor: Color.blue
                        ),
                        PartData(
                            index: 5,
                            content: .label("C++"),
                            area: .degree(60),
                            fillColor: Color.orange
                        ),
                    ]
                )
            )
        }
    }
}
