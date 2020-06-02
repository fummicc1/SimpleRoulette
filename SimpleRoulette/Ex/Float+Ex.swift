//
//  Radian.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/05/29.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    func radian() -> CGFloat {
        CGFloat.pi * (self/180)
    }
    
    func degree() -> CGFloat {
        self / CGFloat.pi * 180
    }
}
