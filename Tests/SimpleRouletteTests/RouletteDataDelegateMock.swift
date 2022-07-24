//
//  RouletteDataDelegateMock.swift
//  
//
//  Created by Fumiya Tanaka on 2022/07/24.
//

import Foundation
import SwiftUI
@testable import SimpleRoulette


public class RouletteDataDelegateMock: RouletteDataDelegate {

    public var totalMock: MockTarget<Double>!
    public var allPartsMock: MockTarget<[PartData]>!

    public var total: Double {
        totalMock.returnValue
    }

    public var allParts: [SimpleRoulette.PartData] {
        allPartsMock.returnValue
    }

    init(totalMock: MockTarget<Double>? = nil, allPartsMock: MockTarget<[PartData]>? = nil) {
        self.totalMock = totalMock
        self.allPartsMock = allPartsMock
    }
}
