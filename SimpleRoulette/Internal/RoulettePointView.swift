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
        // MARK: Head
        let length: CGFloat = rect.width
        let radian: Double = Double(60).radian()
        UIColor.systemOrange.setStroke()
        let originY = rect.maxY
        let originX = rect.midX
        path.move(to: .init(x: originX, y: originY))
        path.addLine(to: .init(x: originX + length * CGFloat(cos(radian)), y: originY - length * CGFloat(sin(radian))))
        /*
         
               /
              /
             /
        */
        path.move(to: .init(x: originX, y: originY))
        path.addLine(to: .init(x: originX - length * CGFloat(cos(radian)), y: originY - length * CGFloat(sin(radian))))
        /*
          
          \    /
           \  /
            \/
        */
        path.addLine(to: .init(x: originX + length * CGFloat(cos(radian)), y: originY - length * CGFloat(sin(radian))))
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
