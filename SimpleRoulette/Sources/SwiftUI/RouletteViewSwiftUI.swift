//
//  RouletteViewSwiftUI.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/09/30.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import SwiftUI
import UIKit

extension Alignment {
    enum HorizontalStackAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.center]
        }
    }
    
    static let horizontalStack: HorizontalAlignment = HorizontalAlignment(HorizontalStackAlignment.self)
    
    static let verticalStack: VerticalAlignment = VerticalAlignment(VerticalStackAlignment.self)
    
    enum VerticalStackAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[VerticalAlignment.center]
        }
        
        
    }
}

public struct RouletteViewSwiftUI: View {
    
    @ObservedObject var viewModel: RouletteViewModel
    
    @State private var radius: CGFloat = 0
    @State private var center: CGPoint = .zero
    @State private var pointSize: CGSize = CGSize(width: 32, height: 32)
    
    var pointView: AnyView
    
    public var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            pointView.frame(width: pointSize.width, height: pointSize.height)
            GeometryReader { geometry in
                ZStack(alignment: Alignment(horizontal: Alignment.horizontalStack, vertical: Alignment.verticalStack)) {
                    content
                    annotations
                }
                .aspectRatio(1, contentMode: .fit)
                .rotationEffect(viewModel.config.angle)
                .onAppear(perform: {
                    radius = min(geometry.size.width / 2, geometry.size.height / 2)
                    let midX = geometry.frame(in: .global).midX
                    let midY = geometry.frame(in: .global).midY
                    center = CGPoint(x: midX, y: midY)
                    if viewModel.state.canStart {
                        viewModel.start()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            viewModel.stop()
                        }
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
//                    .alignmentGuide(Alignment.horizontalStack, computeValue: { (dimension) -> CGFloat in
//                        let mean = (part.startRadianAngle + part.endRadianAngle) / 2
//                        let x: CGFloat = radius / 2 * CGFloat(cos(mean))
//                        return dimension[HorizontalAlignment.center] + x
//                    })
//                    .alignmentGuide(Alignment.verticalStack, computeValue: { (dimension) -> CGFloat in
//                        let mean = (part.startRadianAngle + part.endRadianAngle) / 2
//                        let y: CGFloat = radius / 2 * CGFloat(sin(mean))
//                        return dimension[VerticalAlignment.center] + y
//                    })
                    .offset(CGSize(width: { _ -> CGFloat in
                        let mean = (part.startRadianAngle + part.endRadianAngle) / 2
                        let x: CGFloat = radius / 2 * CGFloat(cos(mean))
                        return x
                    }(()), height: { _ -> CGFloat in
                        let mean = (part.startRadianAngle + part.endRadianAngle) / 2
                        let y: CGFloat = radius / 2 * CGFloat(sin(mean))
                        return y
                    }(())))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: radius * 0.8, maxHeight: radius * 0.8, alignment: Alignment(horizontal: Alignment.horizontalStack, vertical: Alignment.verticalStack))
            )
        }
    }
    
    private var content: some View {
        ForEach(viewModel.parts.indices) { (index: Int) -> AnyView in
            let part = viewModel.parts[index]
            return AnyView(
                RouletteShape(
                    startAngle: Angle(radians: part.startRadianAngle),
                    endAngle: Angle(radians: part.endRadianAngle),
                    radius: radius,
                    center: center,
                    fillColor: Color(part.fillColor),
                    strokeColor: Color(part.strokeColor))
                    .offset(CGSize(width: 0, height: -radius))
            )
        }
    }
    
    public init(viewModel: RouletteViewModel, pointView: AnyView? = nil) {
        self.viewModel = viewModel
        if let pointView = pointView {
            self.pointView = pointView
        } else {
            self.pointView = AnyView(Image(systemName: "arrowtriangle.down").font(.system(size: 32)))
        }
    }
}

struct RouletteViewSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = RouletteViewModel()
        viewModel.updateParts([
            Roulette.HugePart(name: "Test A", huge: .normal, delegate: viewModel, index: 0),
            Roulette.HugePart(name: "Test B", huge: .normal, delegate: viewModel, index: 1),
            Roulette.HugePart(name: "Test C", huge: .normal, delegate: viewModel, index: 2),
            Roulette.HugePart(name: "Test D", huge: .normal, delegate: viewModel, index: 3),
        ])
        return RouletteViewSwiftUI(viewModel: viewModel)
    }
}
