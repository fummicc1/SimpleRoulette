//
//  RouletteShape.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/10/01.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import SwiftUI

struct RouletteShape: Shape {
    var start: CGFloat
    var end: CGFloat
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: start)
        }
    }
}

struct RouletteShape_Previews: PreviewProvider {
    static var previews: some View {
        RouletteShape()
    }
}
