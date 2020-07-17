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
        var length: AccurateCGFloat = .init(value: rect.width)
        let radian: AccurateDouble = .init(value: 60.radian())
        var originY: AccurateCGFloat = .init(value: rect.maxY)
        var originX: AccurateCGFloat = .init(value: rect.midX)
        
        path.move(to:
            .init(x: originX.value, y: originY.value)
        )
        
        var x = originX + length * AccurateCGFloat(value: CGFloat(cos(radian.value)))
        var y = originY - length * AccurateCGFloat(value: CGFloat(sin(radian.value)))
        
        path.addLine(to:
            .init(
                x: x.value,
                y: y.value
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
        
        x = originX - length * AccurateCGFloat(value: CGFloat(cos(radian.value)))
        y = originY - length * AccurateCGFloat(value: CGFloat(sin(radian.value)))
        path.addLine(to:
            .init(
                x: x.value,
                y: y.value
            )
        )
        /*
          
          \    /
           \  /
            \/
        */
        x = originX + length * AccurateCGFloat(value: CGFloat(cos(radian.value)))
        y = originY - length * AccurateCGFloat(value: CGFloat(sin(radian.value)))
        path.addLine(to:
            .init(
                x: x.value,
                y: y.value
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
