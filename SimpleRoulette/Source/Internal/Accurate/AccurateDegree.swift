//
//  AccurateDegree.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/08/16.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation

struct AccurateDegree<Value: AccuracyType> {
    private(set) var value: Value
    private(set) var isRadian: Bool
    
    mutating func update(_ value: Value, isRadian: Bool) {
        self.isRadian = isRadian
        self.value = value
    }
}
