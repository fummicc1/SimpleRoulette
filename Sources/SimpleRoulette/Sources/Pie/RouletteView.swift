//
//  RouletteViewSwiftUI.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/09/30.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import SwiftUI

public struct RouletteView: View {
    
    @StateObject var model: RouletteModel

    @State private var currentAngle: Angle = .init()
    @State private var radius: CGFloat = 0
    @State private var center: CGPoint = .zero
    @State private var length: CGFloat

    let stopView: () -> AnyView
    
    public var body: some View {
        VStack {
            stopView()
            GeometryReader { geometry in
                content
                    .aspectRatio(1, contentMode: .fit)
                    .rotationEffect(currentAngle)
                    .onAppear(perform: {
                        let midX = geometry.frame(in: .local).midX
                        let midY = geometry.frame(in: .local).midY
                        let centerValue = min(midX, midY)
                        center = CGPoint(
                            x: centerValue,
                            y: centerValue
                        )
                        radius = centerValue
                    })
                    .onReceive(model.$state, perform: { state in
                        withAnimation(.easeOut(duration: model.duration)) {
                            self.currentAngle = state.angle
                        }
                    })
            }
            .frame(width: length, height: length)
        }
    }
    
    private var content: some View {
        ForEach(model.parts, id: \.self) { (part) -> RoulettePart in
            RoulettePart(
                data: part,
                center: center,
                radius: radius
            )
        }
    }
    
    public init(
        model: RouletteModel,
        stopView: (() -> AnyView)?,
        length: CGFloat = 320
    ) {
        self._length = State(initialValue: length)
        self._model = StateObject(wrappedValue: model)
        if let stopView = stopView {
            self.stopView = stopView
        } else {
            self.stopView = {
                AnyView(
                    Image(systemName: "arrowtriangle.down")
                        .font(.system(.title))
                        .fixedSize()
                )
            }
        }
    }
}
