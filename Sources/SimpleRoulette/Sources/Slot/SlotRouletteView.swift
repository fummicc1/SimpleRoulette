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
        ZStack {
            VStack {
                ForEach(model.state.values) { value in
                    Text(value.value)
                        .font(.title)
                        .bold()
                        .padding()
                        .foregroundColor(value.foregroundColor)
                        .background(value.backgroundColor)
                        .cornerRadius(8)
                        .frame(height: 40)
                }
            }
            // If I assign 0 to y, z axis, `ignoring singular matrix` warning will appear.
            .rotation3DEffect(
                model.state.angle,
                axis: (x: 1, y: 0.001, z: 0.001),
                anchorZ: -50
            )
            .zIndex(Double(-(Int(model.state.angle.degrees) % 360) + 80))
            Color.black.zIndex(-5)
        }
        .frame(height: CGFloat(model.state.values.count) * 40)
        .clipped()
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
