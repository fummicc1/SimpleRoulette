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
    @State private var decidedPart: RoulettePartType?
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
                part.content?() ?? AnyView(Text(part.label))
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
            duration: 5,
            huges: [
                .init(
                    label: "10",
                    huge: .normal,
                    content: {
                        AnyView(
                            Image(systemName: "10.square")
                                .resizable()
                                .frame(width: 32, height: 32)
                        )
                    }
                ),
                .init(
                    label: "2",
                    huge: .normal,
                    content: {
                        AnyView(
                            Image(systemName: "2.square")
                                .resizable()
                                .frame(width: 32, height: 32)
                        )
                    }
                ),
                .init(
                    label: "5",
                    huge: .normal,
                    content: {
                        AnyView(
                            Image(systemName: "5.square")
                                .resizable()
                                .frame(width: 32, height: 32)
                        )
                    }
                ),
                .init(
                    label: "3",
                    huge: .normal,
                    content: {
                        AnyView(
                            Image(systemName: "3.square")
                                .resizable()
                                .frame(width: 32, height: 32)
                        )
                    }
                )
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
