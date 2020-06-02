//
//  CGFloat+Ex.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/06/02.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    func radian() -> Self {
        Self.pi * (self/180)
    }
    
    func degree() -> Self {
        self / Self.pi * 180
    }
    
    func accurate() -> AccurateCGFloat {
        .init(value: self)
    }
}
