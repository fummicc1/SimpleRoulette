//
//  Operator.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/06/02.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation

infix operator ~=~

func ~=~<Accuracy: AccuracyType>( rhs: inout Accuracy, lhs: Accuracy) -> Bool where Accuracy.Value == Double {
    rhs.subtract(lhs, mutate: false).truncatingRemainder(dividingBy: Double.pi * 2) == 0
}

func +<Accuracy: AccuracyType>(rhs: inout Accuracy, lhs: Accuracy) -> Accuracy {
    return rhs.add(lhs, mutate: false)
}

func -<Accuracy: AccuracyType>(rhs: inout Accuracy, lhs: Accuracy) -> Accuracy.Value {
    return rhs.subtract(lhs, mutate: false)
}

func *<Accuracy: AccuracyType>(rhs: inout Accuracy, lhs: Accuracy) -> Accuracy.Value {
    return rhs.multiply(with: lhs, mutate: false)
}

func /<Accuracy: AccuracyType>(rhs: inout Accuracy, lhs: Accuracy) -> Accuracy.Value {
    return rhs.divide(by: lhs, mutate: false)
}
