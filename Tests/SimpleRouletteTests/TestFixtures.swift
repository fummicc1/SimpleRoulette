import SwiftUI
@testable import SimpleRoulette

func makeParts(_ areas: [PartArea]) -> [PartData] {
    var parts = areas.enumerated().map { index, area in
        PartData(index: index, content: .label("P\(index)"), area: area)
    }
    parts.calculateAngles()
    return parts
}

enum Fixture {
    static let quarters = makeParts([.flex(1), .flex(1), .flex(1), .flex(1)])
    static let mixed = makeParts([.degree(60), .flex(1), .flex(2)])
    static let wide = makeParts([.degree(300), .degree(60)])
    static let gapped = makeParts([.degree(90), .degree(90)])
    static let sevenths = makeParts(Array(repeating: .flex(1), count: 7))
}
