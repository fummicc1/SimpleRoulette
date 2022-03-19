//
//  SlotRouletteZoneView.swift
//  
//
//  Created by Fumiya Tanaka on 2022/02/06.
//

import SwiftUI

struct SlotRouletteZoneView: View {

    @Binding var angle: Angle
    @Binding var title: String
    @Binding var speed: SlotRouletteSpeed
    var foregroundColor: Color
    var backgroundColor: Color

    var body: some View {
        ZStack {
            Text("あああああ")
            Text("BBBBBB")
            Text(title)
        }
            .font(.title)
        // If I assign 0 to y, z axis, `ignoring singular matrix` warning will appear.
            .rotation3DEffect(angle, axis: (x: 1, y: 0.001, z: 0.001))
            .padding()
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(8)
    }
}

struct SlotRouletteZoneView_Previews: PreviewProvider {
    static var previews: some View {
        SlotRouletteZoneView(
            angle: .constant(.zero),
            title: .constant("Test"),
            speed: .constant(SlotRouletteSpeed.slow),
            foregroundColor: .white,
            backgroundColor: Color.blue
        )
    }
}
