//
//  SettingScreen.swift
//  Dotto
//
//  Created by Kanta Oikawa on 2026/04/11.
//

import ComposableArchitecture
import SwiftUI

struct SettingScreen: View {
    private let store: StoreOf<SettingFeature>

    init(
        store: StoreOf<SettingFeature>
    ) {
        self.store = store
    }

    var body: some View {
        NavigationStack {
            List {
                if let user = store.user {
                    UserView(user: user)
                    Button("Sign Out") {
                        store.send(.onSignOutButtonTapped)
                    }
                } else {
                    Button("Sign In") {
                        store.send(.onSignInButtonTapped)
                    }
                }
            }
            .navigationTitle("Setting")
        }
    }
}

#Preview {
    SettingScreen(
        store: Store(initialState: .init()) {
            SettingFeature()
        }
    )
}
