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
    
    @State private var length: CGFloat
    @State private var radius: CGFloat = 0
    @State private var center: CGPoint = .zero
    @State private var currentAngle: Angle = .init()

    let pointView: AnyView
    
    public var body: some View {
        VStack {
            self.makePointView()
            GeometryReader { geometry in
                content
                    .aspectRatio(1, contentMode: .fit)
                    .rotationEffect(currentAngle)
                    .onAppear(perform: {
                        let midX = geometry.frame(in: .local).midX
                        let midY = geometry.frame(in: .local).midY
                        let centerValue = min(midX, midY)
                        center = CGPoint(x: centerValue, y: centerValue)
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
        ForEach(model.parts.indices, id: \.self) { (index: Int) -> PartView in
            let part = model.parts[index]
            return PartView(
                radius: radius,
                center: center,
                part: part,
                currentAngle: model.state.angle
            )
        }
    }

    private func makePointView() -> some View {
        return pointView
    }
    
    public init(
        model: RouletteModel,
        pointView: AnyView? = nil,
        length: CGFloat = 320
    ) {
        self._length = State(initialValue: length)
        self._model = StateObject(wrappedValue: model)
        if let pointView = pointView {
            self.pointView = pointView
        } else {
            self.pointView = AnyView(
                Image(systemName: "arrowtriangle.down")
                    .font(.system(.title))
                    .fixedSize()
            )
        }
    }
}


struct RouletteView_Previews: PreviewProvider {

    static private let model = RouletteModel(
        duration: 5,
        huges: [
            .init(
                label: "10",
                huge: .normal,
                content: {
                    AnyView(
                        Image(systemName: "10.square")
                            .resizable()
                            .frame(width: 56, height: 56)
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
                            .frame(width: 56, height: 56)
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
                            .frame(width: 56, height: 56)
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
                            .frame(width: 56, height: 56)
                    )
                }
            )
        ]
    )

    static var previews: some View {
        return RouletteView(
            model: model,
            length: 240
        )
    }
}
