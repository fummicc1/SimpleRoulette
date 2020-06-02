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
    func add(_ v: Value) -> Value
    
    @discardableResult
    func subtract(_ v: Value) -> Value
    
    @discardableResult
    func multiply(with v: Value) -> Value
    
    @discardableResult
    func divide(by v: Value) -> Value
}
