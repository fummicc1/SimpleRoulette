//
//  Color+Ex.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/10/09.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public extension Color {
    static var secondarySystemBackground: Color {
        #if canImport(UIKit)
        return Color(UIColor.secondarySystemBackground)
        #elseif canImport(AppKit)
        return Color(NSColor.windowBackgroundColor)
        #endif
    }

    static var systemGray: Color {
        #if canImport(UIKit)
        return Color(UIColor.systemGray)
        #elseif canImport(AppKit)
        return Color(NSColor.systemGray)
        #endif
    }
}
