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

    var body: some View {
        Text(title)
            .font(.title)
            .bold()
            .rotation3DEffect(angle, axis: (x: 0, y: 0, z: 0))
            .padding()
    }
}

struct SlotRouletteZoneView_Previews: PreviewProvider {
    static var previews: some View {
        SlotRouletteZoneView(
            angle: .constant(.zero),
            title: .constant("Test")
        )
    }
}
