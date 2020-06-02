//
//  RoulettePointView.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/05/31.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import UIKit

class RoulettePointView: UIView {
    
    override func draw(_ rect: CGRect) {
        let path: UIBezierPath = .init()
        UIColor.systemOrange.setStroke()
        
        // MARK: Head
        var length: AccurateCGFloat = .init(value: rect.width)
        let radian: AccurateDouble = .init(value: 60.radian())
        var originY: AccurateCGFloat = .init(value: rect.maxY)
        var originX: AccurateCGFloat = .init(value: rect.midX)
        
        path.move(to:
            .init(x: originX.value, y: originY.value)
        )
        
        path.addLine(to:
            .init(
                x: originX.add(length.multiply(with: CGFloat(cos(radian.value)))),
                y: originY.subtract(length.multiply(with: CGFloat(sin(radian.value))))
            )
        )
        /*
         
               /
              /
             /
        */
        path.move(to:
            .init(x: originX.value, y: originY.value)
        )
        
        path.addLine(to:
            .init(
                x: originX.subtract(length.multiply(with: CGFloat(cos(radian.value)))),
                y: originY.subtract(length.multiply(with: CGFloat(sin(radian.value))))
            )
        )
        /*
          
          \    /
           \  /
            \/
        */
        path.addLine(to:
            .init(
                x: originX.add(length.multiply(with: CGFloat(cos(radian.value)))),
                y: originY.subtract(length.multiply(with: CGFloat(sin(radian.value))))
            )
        )
        /*
         ______
         \    /
          \  /
           \/
        */
        path.lineWidth = 2
        path.stroke()
    }
}
