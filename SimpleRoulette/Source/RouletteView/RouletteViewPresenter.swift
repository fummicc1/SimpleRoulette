//
//  RouletteViewPresenter.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/06/03.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import UIKit

public protocol RouletteViewPresenterType: AnyObject {
    var isAnimating: Bool { get }
    var roulettePointViewSize: CGSize { get }
    var parts: [RoulettePartType] { get }
}
