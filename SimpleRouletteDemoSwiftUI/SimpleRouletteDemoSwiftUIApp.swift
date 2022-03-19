//
//  SimpleRouletteDemoSwiftUIApp.swift
//  SimpleRouletteDemoSwiftUI
//
//  Created by Fumiya Tanaka on 2020/10/25.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import SwiftUI
import SimpleRoulette

@main
struct SimpleRouletteDemoSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView().tabItem {
                    Text("Simple")
                }
                SlotExampleView(
                    model: SlotRouletteModel(
                        values: [
                            SlotRouletteItem(value: "Test 1", foregroundColor: .white, backgroundColor: Color.red),
                            SlotRouletteItem(value: "Test 2", foregroundColor: .white, backgroundColor: Color.green),
                            SlotRouletteItem(value: "Test 3", foregroundColor: .white, backgroundColor: Color.orange)
                        ],
                        count: 3
                    )
                ).tabItem {
                    Text("Slot")
                }
            }
        }
    }
}
