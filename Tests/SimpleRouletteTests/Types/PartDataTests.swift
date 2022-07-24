//
//  PartDataTests.swift
//  
//
//  Created by Fumiya Tanaka on 2022/07/24.
//

import XCTest
import SwiftUI
@testable import SimpleRoulette

final class PartDataTests: XCTestCase {

    let delegateMock = RouletteDataDelegateMock()

    var allParts: [PartData] = []

    private func correspondWithDelegate(parts: inout [PartData], delegate: RouletteDataDelegateMock) {
        delegate.allPartsMock = .init(returnValue: parts)
        delegate.totalMock = .init(returnValue: 360)

        parts.indices.forEach { index in
            parts[index].assignDelegate(delegate)
        }
    }


    func test_getDegree_calculate_equal_size() {
        // MARK: Arrange
        allParts = (0..<10).map { index in
            PartData(
                index: index,
                content: Content.label("PartData\(index)"),
                area: .flex(1)
            )
        }
        correspondWithDelegate(parts: &allParts, delegate: delegateMock)

        let expected: Double = delegateMock.total / Double(delegateMock.allParts.count)
        let allArea = allParts.map(\.area)

        // MARK: Act
        for part in allParts {
            // MARK: Assert
            XCTAssertEqual(part.area.getDegree(all: allArea), expected)
        }
    }
}
