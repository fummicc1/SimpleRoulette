//
//  PartContentView.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/06/09.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import UIKit

class PartContentView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.strokeColor = UIColor.systemGray4.cgColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        layer.strokeColor = UIColor.systemGray4.cgColor
    }
}

extension PartContentView {
    override class var layerClass: AnyClass {
        CAShapeLayer.self
    }
    
    override var layer: CAShapeLayer {
        super.layer as! CAShapeLayer
    }
}
