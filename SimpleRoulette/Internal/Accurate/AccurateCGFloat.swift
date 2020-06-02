//
//  AccurateCGFloat.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/06/02.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import UIKit

struct AccurateCGFloat: AccuracyType {
    typealias Value = CGFloat
    
    private var _value: Value
    
    init(value: Value) {
        self._value = value
    }
    
    var value: Value {
        _value
    }
    
    @discardableResult
    mutating func add(_ v: Value) -> Value {
        let vStr = String(describing: v)
        let vDecimal = NSDecimalNumber(string: vStr)
        let valueStr = String(describing: value)
        let valueDecimal = NSDecimalNumber(string: valueStr)
        _value = CGFloat(valueDecimal.adding(vDecimal).floatValue)
        return value
    }
    
    @discardableResult
    mutating func subtract(_ v: Value) -> Value {
        let vStr = String(describing: v)
        let vDecimal = NSDecimalNumber(string: vStr)
        let valueStr = String(describing: value)
        let valueDecimal = NSDecimalNumber(string: valueStr)
        _value = CGFloat(valueDecimal.subtracting(vDecimal).floatValue)
        return value
    }
    
    @discardableResult
    mutating func multiply(with v: Value) -> Value {
        let vStr = String(describing: v)
        let vDecimal = NSDecimalNumber(string: vStr)
        let valueStr = String(describing: value)
        let valueDecimal = NSDecimalNumber(string: valueStr)
        _value = CGFloat(valueDecimal.multiplying(by: vDecimal).floatValue)
        return value
    }
    
    @discardableResult
    mutating func divide(by v: Value) -> Value {
        let vStr = String(describing: v)
        let vDecimal = NSDecimalNumber(string: vStr)
        let valueStr = String(describing: value)
        let valueDecimal = NSDecimalNumber(string: valueStr)
        _value = CGFloat(valueDecimal.dividing(by: vDecimal).floatValue)
        return value
    }
    
    @discardableResult
    mutating func add<Accuracy>(_ accuray: Accuracy) -> CGFloat where Accuracy : AccuracyType, Self.Value == Accuracy.Value {
        let vStr = String(describing: accuray.value)
        let vDecimal = NSDecimalNumber(string: vStr)
        let valueStr = String(describing: value)
        let valueDecimal = NSDecimalNumber(string: valueStr)
        _value = CGFloat(valueDecimal.adding(vDecimal).floatValue)
        return value
    }
    
    @discardableResult
    mutating func subtract<Accuracy>(_ accuray: Accuracy) -> CGFloat where Accuracy : AccuracyType, Self.Value == Accuracy.Value {
        let vStr = String(describing: accuray.value)
        let vDecimal = NSDecimalNumber(string: vStr)
        let valueStr = String(describing: value)
        let valueDecimal = NSDecimalNumber(string: valueStr)
        _value = CGFloat(valueDecimal.subtracting(vDecimal).floatValue)
        return value
    }
    
    @discardableResult
    mutating func multiply<Accuracy>(with accuray: Accuracy) -> CGFloat where Accuracy : AccuracyType, Self.Value == Accuracy.Value {
        let vStr = String(describing: accuray.value)
        let vDecimal = NSDecimalNumber(string: vStr)
        let valueStr = String(describing: value)
        let valueDecimal = NSDecimalNumber(string: valueStr)
        _value = CGFloat(valueDecimal.multiplying(by: vDecimal).floatValue)
        return value
    }
    
    @discardableResult
    mutating func divide<Accuracy>(by accuray: Accuracy) -> CGFloat where Accuracy : AccuracyType, Self.Value == Accuracy.Value {
        let vStr = String(describing: accuray.value)
        let vDecimal = NSDecimalNumber(string: vStr)
        let valueStr = String(describing: value)
        let valueDecimal = NSDecimalNumber(string: valueStr)
        _value = CGFloat(valueDecimal.dividing(by: vDecimal).floatValue)
        return value
    }
}
