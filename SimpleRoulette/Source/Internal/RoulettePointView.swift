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
    
    private var size: CGSize = .zero
    
    init(frame: CGRect = .zero, size: CGSize) {
        self.size = size
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var intrinsicContentSize: CGSize {
        size
    }
    
    override func draw(_ rect: CGRect) {
        let path: UIBezierPath = .init()
        UIColor.systemOrange.setStroke()
        
        // MARK: Head
        var length = rect.width
        let radian = 60.radian()
        var originY = rect.maxY
        var originX = rect.midX
        
        path.move(to:
            .init(x: originX, y: originY)
        )
        
        var x = length.multiply(with: CGFloat(cos(radian)), mutate: false)
        _ = x.add(originX, mutate: true)
        var y = length.multiply(with: CGFloat(sin(radian)), mutate: false)
        y = originY.subtract(y, mutate: false)
        
        path.addLine(to:
            .init(
                x: x,
                y: y
            )
        )
        /*
         
               /
              /
             /
        */
        path.move(to:
            .init(x: originX, y: originY)
        )
        
        x = length.multiply(with: CGFloat(cos(radian)), mutate: false)
        x = originX.subtract(x, mutate: false)
        y = length.multiply(with: CGFloat(sin(radian)), mutate: false)
        y = originY.subtract(y, mutate: false)
        
        path.addLine(to:
            .init(
                x: x,
                y: y
            )
        )
        /*
          
          \    /
           \  /
            \/
        */
        x = originX.add(length, mutate: false)
        y = length.multiply(with: CGFloat(sin(radian)), mutate: false)
        y = originY.subtract(y, mutate: false)
        
        path.addLine(to:
            .init(
                x: x,
                y: y
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
