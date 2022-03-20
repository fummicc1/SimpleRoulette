//
//  DemoApp.swift
//  Shared
//
//  Created by Fumiya Tanaka on 2022/03/20.
//  Copyright © 2022 Fumiya Tanaka. All rights reserved.
//

import SwiftUI
import SimpleRoulette

func generateFirstRouletteParts() -> [Roulette.HugePart.Config] {
    return (0...4).map { index in
        Roulette.HugePart.Config(
            label: "\(index)",
            huge: .normal
        ) {
            AnyView(
                Image(systemName: "\(index).square")
                    .resizable()
                    .frame(width: 32, height: 32)
            )
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
                    viewModel: RouletteViewModel(
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
                        viewModel: RouletteViewModel(
                            duration: 5,
                            huges: generateFirstRouletteParts()
                        ),
                        length: 160
                    )
                    Spacer()
                        .frame(width: 12)
                    ContentView(
                        viewModel: RouletteViewModel(
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
