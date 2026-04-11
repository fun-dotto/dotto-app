//
//  ContentView.swift
//  Dotto
//
//  Created by Kanta Oikawa on 2026/04/07.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Settings", systemImage: "gear") {
                SettingScreen(
                    store: Store(initialState: .init()) {
                        SettingFeature()
                    }
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
