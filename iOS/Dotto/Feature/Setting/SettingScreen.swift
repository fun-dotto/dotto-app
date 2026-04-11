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
                Section {
                    if let user = store.user {
                        UserView(user: user)
                        Button("Sign Out") {
                            store.send(.onSignOutButtonTapped)
                        }
                    } else {
                        Button("Sign In") {
                            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                  let viewController = windowScene.windows.first?.rootViewController else {
                                return
                            }
                            store.send(.onSignInButtonTapped(viewController: viewController))
                        }
                    }
                }

                Section {
                    NavigationLink {
                        AnnouncementScreen(
                            store: Store(initialState: .init()) {
                                AnnouncementFeature()
                            }
                        )
                    } label: {
                        Label("お知らせ", systemImage: "bell")
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .onAppear {
            store.send(.onAppear)
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
