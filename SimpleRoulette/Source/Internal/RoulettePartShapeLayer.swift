//
//  RoulettePartLayer.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/07/17.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import UIKit

protocol RoulettePartLayer {
    var part: RoulettePartType? { get }
}

class RoulettePartShapeLayer: CAShapeLayer, RoulettePartLayer {
    var part: RoulettePartType?
    
    static func ==(rhs: RoulettePartShapeLayer, lhs: RoulettePartShapeLayer) -> Bool {
        lhs.part?.id == rhs.part?.id
    }
}
