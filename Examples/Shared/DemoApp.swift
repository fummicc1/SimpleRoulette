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

    @State private var title: String = "Demo"

    var body: some Scene {
        WindowGroup {
            /// please change ``DemoApp/roulette`` and ``DemoApp/content``
//            roulette.navigationTitle(title)
             content
        }
    }

    var roulette: some View {
        RouletteView(
            parts: partDatas
        )
        .startOnAppear(automaticallyStopAfter: 5) { part in
            guard let text = part.content.text else {
                return
            }
            title = text
        }
    }

    var content: some View {
        ContentView(
            model: RouletteModel(
                parts: partDatas
            )
        )
    }

    var partDatas: [PartData] {
        [
            PartData(
                content: .label("Swift"),
                area: .flex(3),
                fillColor: Color.red
            ),
            PartData(
                content: .label("Kotlin"),
                area: .flex(1),
                fillColor: Color.purple
            ),
            PartData(
                content: .label("JavaScript"),
                area: .flex(2),
                fillColor: Color.yellow
            ),
            PartData(
                content: .label("Dart"),
                area: .flex(1),
                fillColor: Color.green
            ),
            PartData(
                content: .label("Python"),
                area: .flex(2),
                fillColor: Color.blue
            ),
            PartData(
                content: .label("C++"),
                area: .degree(60),
                fillColor: Color.orange
            ),
        ]
    }
}
