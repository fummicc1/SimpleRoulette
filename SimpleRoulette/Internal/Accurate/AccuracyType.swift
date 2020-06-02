//
//  Accuratable.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/06/02.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation

protocol AccuracyType {
    associatedtype Value
    var value: Value { get }
    
    @discardableResult
    mutating func add(_ v: Value) -> Value
    
    @discardableResult
    mutating func subtract(_ v: Value) -> Value
    
    @discardableResult
    mutating func multiply(with v: Value) -> Value
    
    @discardableResult
    mutating func divide(by v: Value) -> Value
    
    @discardableResult
    mutating func add<Accuracy: AccuracyType>(_ accuray: Accuracy) -> Value where Accuracy.Value == Self.Value
    
    @discardableResult
    mutating func subtract<Accuracy: AccuracyType>(_ accuray: Accuracy) -> Value where Accuracy.Value == Self.Value
    
    @discardableResult
    mutating func multiply<Accuracy: AccuracyType>(with accuray: Accuracy) -> Value where Accuracy.Value == Self.Value
    
    @discardableResult
    mutating func divide<Accuracy: AccuracyType>(by accuray: Accuracy) -> Value where Accuracy.Value == Self.Value
}
