//
//  RouletteViewSwiftUI.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/09/30.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import SwiftUI
import UIKit

public struct RouletteView: View {
    
    @StateObject var viewModel: RouletteViewModel
    
    @State private var radius: CGFloat = 0
    @State private var center: CGPoint = .zero
    @State private var currentAngle: Angle = .init()
    
    let pointSize: CGSize = CGSize(width: 32, height: 32)
    let pointView: AnyView
    
    public var body: some View {
        VStack {
            Spacer()
            pointView.frame(width: pointSize.width, height: pointSize.height)
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
                    .onReceive(viewModel.$state, perform: { state in
                        withAnimation(.easeOut(duration: viewModel.duration)) {
                            self.currentAngle = state.angle
                        }
                    })
            }
            Spacer()
        }
    }
    
    private var annotations: some View {
        ForEach(viewModel.parts.indices) { (index: Int) -> AnyView in
            let part = viewModel.parts[index]
            return AnyView(
                Text(part.name)
                    .offset(CGSize(width: { _ -> CGFloat in
                        let mean = (part.startRadian + part.endRadian) / 2
                        let x: CGFloat = radius / 2 * CGFloat(cos(mean))
                        return x
                    }(()), height: { _ -> CGFloat in
                        let mean = (part.startRadian + part.endRadian) / 2
                        let y: CGFloat = radius / 2 * CGFloat(sin(mean))
                        return y
                    }(())))
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: radius * 0.8, maxHeight: radius * 0.8)
            )
        }
    }
    
    private var content: some View {
        ForEach(viewModel.parts.indices) { (index: Int) -> RoulettePartSwiftUIView in
            let part = viewModel.parts[index]
            return RoulettePartSwiftUIView(
                radius: radius,
                center: center,
                part: part,
                currentAngle: viewModel.state.angle
            )
        }
    }
    
    public init(viewModel: RouletteViewModel, pointView: AnyView? = nil) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        if let pointView = pointView {
            self.pointView = pointView
        } else {
            self.pointView = AnyView(Image(systemName: "arrowtriangle.down").font(.system(size: 32)))
        }
    }
}

struct RouletteView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = RouletteViewModel(duration: 5)
        viewModel.configureWithHuge(
            RouletteHugeConfigurable(
                name: "Test A",
                huge: .normal
            ),
            RouletteHugeConfigurable(
                name: "Test B",
                huge: .normal
            ),
            RouletteHugeConfigurable(
                name: "Test C",
                huge: .normal
            ),
            RouletteHugeConfigurable(
                name: "Test D",
                huge: .normal
            )
        )
        return RouletteView(viewModel: viewModel)
    }
}
