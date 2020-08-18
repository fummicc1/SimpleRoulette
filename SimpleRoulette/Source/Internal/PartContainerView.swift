//
//  PartContentView.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/06/09.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import UIKit

class PartContainerView: UIView {
    
    private var _intrinsicContentSize: CGSize = .zero
    
    public func updateIntrinsicContentSize(_ contentSize: CGSize) {
        _intrinsicContentSize = contentSize
        invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        _intrinsicContentSize
    }
}
