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
        viewModel.configureWithHuge(
            RouletteHugeConfigurable(name: "Title A", huge: .large, fill: UIColor.systemTeal.color),
            RouletteHugeConfigurable(name: "Title B", huge: .small, fill: UIColor.systemBlue.color),
            RouletteHugeConfigurable(name: "Title C", huge: .normal, fill: UIColor.systemRed.color)
        )
        return viewModel
    }()
    @State private var decidedPart: RoulettePartType?
    
    var body: some View {
        VStack {
            Spacer()
            RouletteView(viewModel: viewModel)
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
