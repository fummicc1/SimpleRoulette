//
//  SlotRouletteView.swift
//  
//
//  Created by Fumiya Tanaka on 2022/02/06.
//

import SwiftUI

struct SlotRouletteView: View {

    @ObservedObject var model: SlotRouletteModel

    var body: some View {
        HStack {
            ForEach($model.states) { state in
                SlotRouletteZoneView(
                    angle: state.worker.angle,
                    title: state.value
                )
            }
        }
    }
}

struct SlotRouletteView_Previews: PreviewProvider {
    static var previews: some View {
        SlotRouletteView(
            model: SlotRouletteModel(
                values: ["ゲーム", "ラーメン", "テスト"],
                count: 3
            )
        )
    }
}
