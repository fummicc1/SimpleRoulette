//
//  MockTarget.swift
//  
//
//  Created by Fumiya Tanaka on 2022/07/24.
//

import Foundation


public struct MockTarget<Value> {
    public var numberOfCalled: Int
    public var returnValue: Value

    public var isCalled: Bool {
        numberOfCalled > 0
    }

    public init(numberOfCalled: Int = 0, returnValue: Value) {
        self.numberOfCalled = numberOfCalled
        self.returnValue = returnValue
    }
}

