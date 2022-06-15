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
    @State private var length: CGFloat = 320

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Text("Decide favorite language !")
                    .font(.largeTitle)
                    .bold().italic()
                    .padding()
                if let decidedPart = decidedPart, let text = decidedPart.content.text {
                    Text("It is \(text)")
                        .font(.title)
                        .italic()
                        .bold()
                        .padding()
                }
                RouletteView(
                    model: model,
                    length: length
                )
                Button("Start") {
                    model.start()
                }
                .buttonStyle(.bordered)
                .font(.title)
                .padding()
                Spacer()
            }
            Spacer()
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
        ContentView(model: defaultModel())
            .previewInterfaceOrientation(.landscapeLeft)
        ContentView(model: defaultModel())
            .previewDevice(PreviewDevice(rawValue: "iPhone 13 mini"))
    }
}
