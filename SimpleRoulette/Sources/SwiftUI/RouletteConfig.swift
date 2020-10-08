//
//  RouletteConfig.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/10/08.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

public final class RouletteConfig: ObservableObject {
    @Published public var angle: Angle = Angle(degrees: 0)
    @Published public var duration: CGFloat = 3
}
