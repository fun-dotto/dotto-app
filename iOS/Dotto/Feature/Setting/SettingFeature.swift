//
//  SettingFeature.swift
//  Dotto
//
//  Created by Kanta Oikawa on 2026/04/11.
//

import ComposableArchitecture
import DottoModel
import SwiftUI

@Reducer
struct SettingFeature {
    @ObservableState
    struct State: Equatable {
        var user: DottoUser?
    }

    enum Action {
        case onSignInButtonTapped(viewController: UIViewController)
        case onSignOutButtonTapped
        case signInResult(Result<DottoUser, Error>)
        case signOutResult(Result<Void, Error>)
    }

    @Dependency(\.authClient) var authClient

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onSignInButtonTapped(let viewController):
                return .run { send in
                    await send(
                        .signInResult(
                            Result {
                                try await authClient.signIn(viewController)
                            }
                        )
                    )
                }

            case .onSignOutButtonTapped:
                return .run { send in
                    await send(
                        .signOutResult(
                            Result {
                                try await authClient.signOut()
                            }
                        )
                    )
                }

            case .signInResult(.success(let user)):
                state.user = user
                return .none

            case .signInResult(.failure):
                return .none

            case .signOutResult(.success):
                state.user = nil
                return .none

            case .signOutResult(.failure):
                return .none
            }
        }
    }
}
