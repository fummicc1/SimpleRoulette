//
//  SlotRouletteView.swift
//  
//
//  Created by Fumiya Tanaka on 2022/02/06.
//

import SwiftUI

public struct SlotRouletteView: View {

    @StateObject public var model: SlotRouletteModel

    public init(model: SlotRouletteModel) {
        self._model = StateObject(wrappedValue: model)
    }

    public var body: some View {
        HStack {
            ForEach($model.states) { state in
                SlotRouletteZoneView(
                    angle: state.angle,
                    title: state.value.value,
                    speed: state.speed,
                    foregroundColor: state.value.foregroundColor.wrappedValue,
                    backgroundColor: state.value.backgroundColor.wrappedValue
                )
            }
        }
    }
}

struct SlotRouletteView_Previews: PreviewProvider {
    static var previews: some View {
        SlotRouletteView(
            model: SlotRouletteModel(
                values: ["ゲーム", "ラーメン", "テスト"].map {
                    SlotRouletteItem(
                        value: $0,
                        foregroundColor: Color.white,
                        backgroundColor: Color.blue
                    )
                },
                count: 3
            )
        )
    }
}
