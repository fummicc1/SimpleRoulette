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
    
    @discardableResult
    mutating func add(_ v: Double) -> Double {
        let vStr = String(v)
        let vDecimal = NSDecimalNumber(string: vStr)
        let valueStr = String(_value)
        let valueDecimal = NSDecimalNumber(string: valueStr)
        _value = valueDecimal.adding(vDecimal).doubleValue
        return value
    }
    
    @discardableResult
    mutating func subtract(_ v: Double) -> Double {
        let vStr = String(v)
        let vDecimal = NSDecimalNumber(string: vStr)
        let valueStr = String(_value)
        let valueDecimal = NSDecimalNumber(string: valueStr)
        _value = valueDecimal.subtracting(vDecimal).doubleValue
        return value
    }
    
    @discardableResult
    mutating func multiply(with v: Double) -> Double {
        let vStr = String(v)
        let vDecimal = NSDecimalNumber(string: vStr)
        let valueStr = String(_value)
        let valueDecimal = NSDecimalNumber(string: valueStr)
        _value = valueDecimal.multiplying(by: vDecimal).doubleValue
        return value
    }
    
    @discardableResult
    mutating func divide(by v: Double) -> Double {
        let vStr = String(v)
        let vDecimal = NSDecimalNumber(string: vStr)
        let valueStr = String(_value)
        let valueDecimal = NSDecimalNumber(string: valueStr)
        _value = valueDecimal.dividing(by: vDecimal).doubleValue
        return value
    }
    
    @discardableResult
    mutating func add<Accuracy>(_ accuray: Accuracy) -> Double where Accuracy : AccuracyType, Self.Value == Accuracy.Value {
        let vStr = String(accuray.value)
        let vDecimal = NSDecimalNumber(string: vStr)
        let valueStr = String(_value)
        let valueDecimal = NSDecimalNumber(string: valueStr)
        _value = valueDecimal.adding(vDecimal).doubleValue
        return value
    }
    
    @discardableResult
    mutating func subtract<Accuracy>(_ accuray: Accuracy) -> Double where Accuracy : AccuracyType, Self.Value == Accuracy.Value {
        let vStr = String(accuray.value)
        let vDecimal = NSDecimalNumber(string: vStr)
        let valueStr = String(_value)
        let valueDecimal = NSDecimalNumber(string: valueStr)
        _value = valueDecimal.subtracting(vDecimal).doubleValue
        return value
    }
    
    @discardableResult
    mutating func multiply<Accuracy>(with accuray: Accuracy) -> Double where Accuracy : AccuracyType, Self.Value == Accuracy.Value {
        let vStr = String(accuray.value)
        let vDecimal = NSDecimalNumber(string: vStr)
        let valueStr = String(_value)
        let valueDecimal = NSDecimalNumber(string: valueStr)
        _value = valueDecimal.multiplying(by: vDecimal).doubleValue
        return value
    }
    
    @discardableResult
    mutating func divide<Accuracy>(by accuray: Accuracy) -> Double where Accuracy : AccuracyType, Self.Value == Accuracy.Value {
        let vStr = String(accuray.value)
        let vDecimal = NSDecimalNumber(string: vStr)
        let valueStr = String(_value)
        let valueDecimal = NSDecimalNumber(string: valueStr)
        _value = valueDecimal.dividing(by: vDecimal).doubleValue
        return value
    }
}
