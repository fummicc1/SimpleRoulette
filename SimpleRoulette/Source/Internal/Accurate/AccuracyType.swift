//
//  Accuratable.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/06/02.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation

protocol AccuracyType: Comparable {
    
    @discardableResult
    mutating func add(_ v: Self, mutate: Bool) -> Self
    
    @discardableResult
    mutating func subtract(_ v: Self, mutate: Bool) -> Self
    
    @discardableResult
    mutating func multiply(with v: Self, mutate: Bool) -> Self
    
    @discardableResult
    mutating func divide(by v: Self, mutate: Bool) -> Self
}
