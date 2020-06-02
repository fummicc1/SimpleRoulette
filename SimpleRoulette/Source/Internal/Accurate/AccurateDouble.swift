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
    
    private var _value: Double
    
    init(value: Double) {
        self._value = value
    }
    
    var value: Double {
        _value
    }
    
    @discardableResult
    mutating func add(_ v: Double, mutate: Bool = false) -> Double {
        if !mutate {
            return value.decimal().adding(v.decimal()).doubleValue
        }
        _value = value.decimal().adding(v.decimal()).doubleValue
        return value
    }
    
    @discardableResult
    mutating func subtract(_ v: Double, mutate: Bool = false) -> Double {
        if !mutate {
            return value.decimal().subtracting(v.decimal()).doubleValue
        }
        _value = value.decimal().subtracting(v.decimal()).doubleValue
        return value
    }
    
    @discardableResult
    mutating func multiply(with v: Double, mutate: Bool = false) -> Double {
        if !mutate {
            return value.decimal().multiplying(by: v.decimal()).doubleValue
        }
        _value = value.decimal().multiplying(by: v.decimal()).doubleValue
        return value
    }
    
    @discardableResult
    mutating func divide(by v: Double, mutate: Bool = false) -> Double {
        if !mutate {
            return value.decimal().dividing(by: v.decimal()).doubleValue
        }
        _value = value.decimal().dividing(by: v.decimal()).doubleValue
        return value
    }
    
    @discardableResult
    mutating func add<Accuracy>(_ accuray: Accuracy, mutate: Bool = false) -> Double where Accuracy : AccuracyType, AccurateDouble.Value == Accuracy.Value {
        add(accuray.value, mutate: mutate)
    }
    
    @discardableResult
    mutating func subtract<Accuracy>(_ accuray: Accuracy, mutate: Bool = false) -> Double where Accuracy : AccuracyType, AccurateDouble.Value == Accuracy.Value {
        subtract(accuray.value, mutate: mutate)
    }
    
    @discardableResult
    mutating func multiply<Accuracy>(with accuray: Accuracy, mutate: Bool = false) -> Double where Accuracy : AccuracyType, AccurateDouble.Value == Accuracy.Value {
        multiply(with: accuray.value, mutate: mutate)
    }
    
    @discardableResult
    mutating func divide<Accuracy>(by accuray: Accuracy, mutate: Bool = false) -> Double where Accuracy : AccuracyType, AccurateDouble.Value == Accuracy.Value {
        divide(by: accuray.value, mutate: mutate)
    }
}
