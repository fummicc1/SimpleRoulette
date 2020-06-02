//
//  Double+Ex.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/06/02.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation

extension Double {
    func radian() -> Self {
        Self.pi * (self/180)
    }
    
    func degree() -> Self {
        self / Self.pi * 180
    }
    
    func accurate() -> AccurateDouble {
        .init(value: self)
    }
    
    func decimal() -> NSDecimalNumber {
        let str = String(self)
        return .init(string: str)
    }
    
    func reverse() -> Self {
        let value = Self.pi * 2 - self
        if value.degree() > 270 {
            return Self.pi * 2 - value
        } else if value.degree() < -90 {
            return Self.pi * 2 + value
        }
        return value
    }
}
