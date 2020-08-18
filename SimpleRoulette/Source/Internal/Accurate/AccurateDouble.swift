//
//  AccurateDouble.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/06/02.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation

extension Double: AccuracyType {
    mutating func add(_ v: Double, mutate: Bool) -> Double {
        let result = self.decimal().adding(v.decimal()).doubleValue
        if mutate {
            self = result
        }
        return result
    }
    
    mutating func subtract(_ v: Double, mutate: Bool) -> Double {
        let result = self.decimal().subtracting(v.decimal()).doubleValue
        if mutate {
            self = result
        }
        return result
    }
    
    mutating func multiply(with v: Double, mutate: Bool) -> Double {
        let result = self.decimal().multiplying(by: v.decimal()).doubleValue
        if mutate {
            self = result
        }
        return result
    }
    
    mutating func divide(by v: Double, mutate: Bool) -> Double {
        let result = self.decimal().dividing(by: v.decimal()).doubleValue
        if mutate {
            self = result
        }
        return result
    }
}
