//
//  ContentView.swift
//  SimpleRouletteDemoSwiftUI
//
//  Created by Fumiya Tanaka on 2020/10/25.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import SwiftUI
import SimpleRoulette

struct ContentView: View {
    @ObservedObject var viewModel: RouletteViewModel = {
        let viewModel = RouletteViewModel(duration: 5)
        viewModel.configureParts([
            Roulette.HugePart(name: "Title A", huge: .large, delegate: viewModel, index: 0),
            Roulette.HugePart(name: "Title B", huge: .small, delegate: viewModel, index: 1),
            Roulette.HugePart(name: "Title C", huge: .normal, delegate: viewModel, index: 2),
        ])
        return viewModel
    }()
    @State private var decidedPart: RoulettePartType?
    
    var body: some View {
        VStack {
            Spacer()
            RouletteViewSwiftUI(viewModel: viewModel)
            Button("Start") {
                viewModel.start(speed: .slow)
            }
            if let part = decidedPart {
                Text(part.name)
            }
            Spacer()
        }
        .onReceive(viewModel.onDecidePublisher) { part in
            decidedPart = part
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
