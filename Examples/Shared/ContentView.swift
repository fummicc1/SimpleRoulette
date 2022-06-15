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
    @ObservedObject var model: RouletteModel
    @State private var decidedPart: PartData?
    let length: CGFloat

    var body: some View {
        VStack {
            RouletteView(
                model: model,
                length: length
            )
            Button("Start") {
                model.start(
                    speed: [RouletteSpeed.slow, .normal, .fast].randomElement()!
                )
            }
            .buttonStyle(.bordered)
            .font(.title)
            if let part = decidedPart {
                part.content.view
            }
        }
        .onReceive(model.onDecidePublisher) { part in
            decidedPart = part
        }
    }
}

struct ContentView_Previews: PreviewProvider {

    static func defaultModel() -> RouletteModel {
        let viewModel = RouletteModel(
            parts: [
                PartData(index: 0, content: .label("0"), area: .flex(1)),
                PartData(index: 1, content: .label("1"), area: .flex(1)),
                PartData(index: 2, content: .label("2"), area: .flex(1)),
                PartData(index: 3, content: .label("3"), area: .flex(1))
            ]
        )
        return viewModel
    }

    static var previews: some View {
        ContentView(model: defaultModel(), length: 240)
            .previewInterfaceOrientation(.landscapeLeft)
        ContentView(model: defaultModel(), length: 240)
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 mini"))
    }
}
