//
//  RoulettePartTextLayer.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/07/17.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import UIKit

class RoulettePartTextLayer: CATextLayer {
    let part: RoulettePartType
    
    init(part: RoulettePartType) {
        self.part = part
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func ==(rhs: RoulettePartTextLayer, lhs: RoulettePartTextLayer) -> Bool {
        lhs.part.id == rhs.part.id
    }
}
