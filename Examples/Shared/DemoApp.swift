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
    @State private var model: RouletteModel
    
    init() {
        self._model = .init(
            initialValue: RouletteModel(
                parts: Self.partDatas
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            /// please change ``DemoApp/roulette`` and ``DemoApp/content``
//            NavigationStack {
//                roulette.navigationTitle(title)
//            }
             content
        }
    }

    var roulette: some View {
        RouletteView(
            model: model
        )
        .onChange(of: model.state) { _, newState in
            if case .stop(let part, _) = newState, let text = part.content.text {
                title = text
            }
        }
        .task {
            try? await Task.sleep(for: .milliseconds(100))
            model.start(
                speed: .random(),
                automaticallyStopAfter: 5
            )
        }
    }

    var content: some View {
        ContentView(
            model: model
        )
    }

    private static var partDatas: [PartData] {
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
