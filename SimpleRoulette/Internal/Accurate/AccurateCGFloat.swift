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
    
    private var _value: CGFloat
    
    init(value: CGFloat) {
        self._value = value
    }
    
    var value: CGFloat {
        _value
    }
    
    @discardableResult
    mutating func add(_ v: CGFloat, mutate: Bool = false) -> CGFloat {
        if !mutate {
            return CGFloat(value.decimal().adding(v.decimal()).doubleValue)
        }
        _value = CGFloat(value.decimal().adding(v.decimal()).doubleValue)
        return value
    }
    
    @discardableResult
    mutating func subtract(_ v: CGFloat, mutate: Bool = false) -> CGFloat {
        if !mutate {
            return CGFloat(value.decimal().subtracting(v.decimal()).doubleValue)
        }
        _value = CGFloat(value.decimal().subtracting(v.decimal()).doubleValue)
        return value
    }
    
    @discardableResult
    mutating func multiply(with v: CGFloat, mutate: Bool = false) -> CGFloat {
        if !mutate {
            return CGFloat(value.decimal().multiplying(by: v.decimal()).doubleValue)
        }
        _value = CGFloat(value.decimal().multiplying(by: v.decimal()).doubleValue)
        return value
    }
    
    @discardableResult
    mutating func divide(by v: CGFloat, mutate: Bool = false) -> CGFloat {
        if !mutate {
            return CGFloat(value.decimal().dividing(by: v.decimal()).doubleValue)
        }
        _value = CGFloat(value.decimal().dividing(by: v.decimal()).doubleValue)
        return value
    }
    
    @discardableResult
    mutating func add<Accuracy>(_ accuray: Accuracy, mutate: Bool = false) -> CGFloat where Accuracy : AccuracyType, Self.Value == Accuracy.Value {
        add(accuray.value, mutate: mutate)
    }
    
    @discardableResult
    mutating func subtract<Accuracy>(_ accuray: Accuracy, mutate: Bool = false) -> CGFloat where Accuracy : AccuracyType, Self.Value == Accuracy.Value {
        subtract(accuray.value, mutate: mutate)
    }
    
    @discardableResult
    mutating func multiply<Accuracy>(with accuray: Accuracy, mutate: Bool = false) -> CGFloat where Accuracy : AccuracyType, Self.Value == Accuracy.Value {
        multiply(with: accuray.value, mutate: mutate)
    }
    
    @discardableResult
    mutating func divide<Accuracy>(by accuray: Accuracy, mutate: Bool = false) -> CGFloat where Accuracy : AccuracyType, Self.Value == Accuracy.Value {
        divide(by: accuray.value, mutate: mutate)
    }
}
