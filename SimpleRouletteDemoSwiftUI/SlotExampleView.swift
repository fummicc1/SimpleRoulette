//
//  SlotExampleView.swift
//  SimpleRouletteDemoSwiftUI
//
//  Created by Fumiya Tanaka on 2022/03/20.
//  Copyright © 2022 Fumiya Tanaka. All rights reserved.
//

import SwiftUI
import SimpleRoulette

struct SlotExampleView: View {

    @StateObject var model: SlotRouletteModel

    var body: some View {
        SlotRouletteView(model: model)
            .onAppear {
                model.start()
            }
    }
}

struct SlotExampleView_Previews: PreviewProvider {
    static var previews: some View {
        SlotExampleView(
            model: SlotRouletteModel(
                values: [
                    SlotRouletteItem(value: "Test 1", foregroundColor: Color.white, backgroundColor: Color.red),
                    SlotRouletteItem(value: "Test 2", foregroundColor: Color.white, backgroundColor: Color.green),
                    SlotRouletteItem(value: "Test 3", foregroundColor: Color.white, backgroundColor: Color.orange)
                ],
                count: 3
            )
        )
    }
}
