//
//  Double+Ex.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/06/02.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation

extension Double {
    func radian() -> Double {
        Double.pi * (self/180)
    }
    
    func degree() -> Double {
        self / Double.pi * 180
    }
}
