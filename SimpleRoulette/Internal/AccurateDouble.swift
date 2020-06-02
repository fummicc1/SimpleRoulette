//
//  AccurateDouble.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/06/02.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation


struct AccurateDouble: AccuracyType {
    typealias Value = Double
    
    private var _value: Value
    
    init(value: Double) {
        self._value = value
    }
    
    var value: Double {
        _value
    }
    
    mutating func add(_ v: Double) -> Double {
        _value += v
        return value
    }
    
    mutating func subtract(_ v: Double) -> Double {
        _value -= v
        return value
    }
    
    mutating func multiply(with v: Double) -> Double {
        _value *= v
        return value
    }
    
    mutating func divide(by v: Double) -> Double {
        _value /= v
        return value
    }
}
