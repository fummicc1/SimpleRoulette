//
//  RouletteViewSwiftUI.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/09/30.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import SwiftUI

public struct RouletteViewSwiftUI: View {
    
    @ObservedObject var viewModel: RouletteViewModel
    
    var pointView: AnyView
    
    public var body: some View {
        VStack {
            pointView
            ZStack {
                content
                Text("Hello")
            }
        }
    }
    
    private var content: some View {
        Path { path in
            
        }
    }
    
    public init(viewModel: RouletteViewModel, pointView: AnyView = AnyView(EmptyView())) {
        self.viewModel = viewModel
        self.pointView = pointView
    }
}

struct RouletteViewSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        RouletteViewSwiftUI(viewModel: RouletteViewModel())
    }
}
