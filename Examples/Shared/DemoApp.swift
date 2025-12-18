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
            NavigationView {
                roulette.navigationTitle(title)
            }
//             content
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
        let elements: [(content: Content, area: PartArea, color: Color)] = [
            (.label("Swift"),      .flex(3),    .red),
            (.label("Kotlin"),     .flex(1),    .purple),
            (.label("JavaScript"), .flex(2),    .yellow),
            (.label("Dart"),       .flex(1),    .green),
            (.label("Python"),     .flex(2),    .blue),
            (.label("C++"),        .degree(60), .orange),
        ]
        return elements.enumerated().map { index, element in
            PartData(
                index: index,
                content: element.content,
                area: element.area,
                fillColor: element.color
            )
        }
    }
}
