//
//  ContentView.swift
//  Shared
//
//  Created by Fumiya Tanaka on 2022/03/20.
//  Copyright © 2022 Fumiya Tanaka. All rights reserved.
//

import SwiftUI
import SimpleRoulette

struct ContentView: View {
    @State var model: RouletteModel
    @State private var length: CGFloat = 320

    var body: some View {
        HStack {
            VStack {
                Spacer().frame(height: 120)
                Text("Decide favorite language !")
                    .font(.title)
                    .bold().italic()
                    .padding()
                Group {
                    if let decidedPart = model.decidedPart, let text = decidedPart.content.text {
                        Text("It is \(text)")
                            .font(.title)
                            .italic()
                            .bold()
                            .padding()
                    } else {
                        Text("Nothing")
                    }
                }.frame(height: 40)
                RouletteView(
                    model: model,
                    length: length
                )
                HStack {
                    Group {
                        Button(model.state.isAnimating ? "Pause" : "Start") {
                            if model.state.isAnimating {
                                model.pause()
                            } else {
                                model.start(speed: .random(), automaticallyStopAfter: 5)
                            }
                        }
                        Button("Stop") {
                            model.stop()
                        }
                    }
                    .buttonStyle(.bordered)
                    .font(.title)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                Spacer()
            }
        }
    }
}

#Preview("Landscape") {
    ContentView(
        model: RouletteModel(
            parts: [
                PartData(index: 0, content: .label("0"), area: .flex(1)),
                PartData(index: 1, content: .label("1"), area: .flex(1)),
                PartData(index: 2, content: .label("2"), area: .flex(1)),
                PartData(index: 3, content: .label("3"), area: .flex(1))
            ]
        )
    )
}

#Preview("iPhone") {
    ContentView(
        model: RouletteModel(
            parts: [
                PartData(index: 0, content: .label("0"), area: .flex(1)),
                PartData(index: 1, content: .label("1"), area: .flex(1)),
                PartData(index: 2, content: .label("2"), area: .flex(1)),
                PartData(index: 3, content: .label("3"), area: .flex(1))
            ]
        )
    )
}
