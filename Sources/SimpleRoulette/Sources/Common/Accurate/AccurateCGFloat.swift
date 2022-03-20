//
//  AccurateCGFloat.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/06/02.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
#if canImport(UIKit)
import UIKit
#endif

extension CGFloat: AccuracyType {
    mutating func add(_ v: CGFloat, mutate: Bool) -> CGFloat {
        let result = self.decimal().adding(v.decimal()).doubleValue
        if mutate {
            self = CGFloat(result)
        }
        return CGFloat(result)
    }
    
    mutating func subtract(_ v: CGFloat, mutate: Bool) -> CGFloat {
        let result = self.decimal().subtracting(v.decimal()).doubleValue
        if mutate {
            self = CGFloat(result)
        }
        return CGFloat(result)
    }
    
    mutating func multiply(with v: CGFloat, mutate: Bool) -> CGFloat {
        let result = self.decimal().multiplying(by: v.decimal()).doubleValue
        if mutate {
            self = CGFloat(result)
        }
        return CGFloat(result)
    }
    
    mutating func divide(by v: CGFloat, mutate: Bool) -> CGFloat {
        let result = self.decimal().dividing(by: v.decimal()).doubleValue
        if mutate {
            self = CGFloat(result)
        }
        return CGFloat(result)
    }
}
