//
//  DemoApp.swift
//  Shared
//
//  Created by Fumiya Tanaka on 2022/03/20.
//  Copyright © 2022 Fumiya Tanaka. All rights reserved.
//

import SwiftUI
import SimpleRoulette

func generateFirstRouletteParts() -> [PartData] {
    return (0...4).map { index in
        let content = Content.custom(
            AnyView(
                Image(systemName: "\(index).square")
                    .resizable()
                    .frame(width: 32, height: 32)
            )
        )
        return PartData(
            index: index,
            content: content,
            area: .flex(1),
            fillColor: <#T##Color#>, strokeColor: <#T##Color#>, lineWidth: <#T##Double#>, delegate: <#T##RoulettePartHugeDelegate?#>)
        Roulette.HugePart.Config(
            label: "\(index)",
            huge: .normal
        ) {

        }
    }
}

func generateSecondRouletteParts() -> [Roulette.HugePart.Config] {
    return (0...4).map { index in
        Roulette.HugePart.Config(
            label: "\(index)",
            huge: index % 2 == 0 ? .small : .large
        ) {
            AnyView(
                Image(systemName: "\(index).square")
                    .resizable()
                    .frame(width: 32, height: 32)
            )
        }
    }
}

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView(
                    model: RouletteModel(
                        duration: 5,
                        huges: generateFirstRouletteParts()
                    ),
                    length: 320
                )
                .tabItem {
                    Text("Single")
                }
                HStack {
                    ContentView(
                        model: RouletteModel(
                            duration: 5,
                            huges: generateFirstRouletteParts()
                        ),
                        length: 160
                    )
                    Spacer()
                        .frame(width: 12)
                    ContentView(
                        model: RouletteModel(
                            duration: 5,
                            huges: generateSecondRouletteParts()
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
