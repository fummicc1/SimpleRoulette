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
            TabView {
                ContentView(
                    model: RouletteModel(
                        parts: [
                            PartData(index: 0, content: .label("Swift"), area: .flex(3)),
                            PartData(index: 1, content: .label("Kotlin"), area: .flex(1)),
                            PartData(index: 2, content: .label("JavaScript"), area: .flex(2)),
                        ]
                    ),
                    length: 320
                )
                .tabItem {
                    Text("Single")
                }
                HStack {
                    ContentView(
                        model: RouletteModel(
                            parts: [
                                PartData(index: 0, content: .label("Ramen"), area: .flex(3)),
                                PartData(index: 1, content: .label("Tomato"), area: .flex(1)),
                                PartData(index: 2, content: .label("Udon"), area: .flex(2)),
                            ]
                        ),
                        length: 160
                    )
                    Spacer()
                        .frame(width: 12)
                    ContentView(
                        model: RouletteModel(
                            parts: [
                                PartData(index: 0, content: .label("Pizza"), area: .flex(3)),
                                PartData(index: 1, content: .label("IceCream"), area: .flex(1)),
                                PartData(index: 2, content: .label("Sushi"), area: .flex(2)),
                            ]
                        ),
                        length: 160
                    )
                }
                .tabItem {
                    Text("HStack")
                }
            }
        }
    }
}
