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
        case onAppear
        case onSignInButtonTapped(viewController: UIViewController)
        case onSignOutButtonTapped
        case getUserResult(Result<DottoUser, Error>)
        case signInResult(Result<DottoUser, Error>)
        case signOutResult(Result<Void, Error>)
    }

    @Dependency(\.authClient) var authClient

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(
                        .getUserResult(
                            Result {
                                try await authClient.getCurrentUser()
                            }
                        )
                    )
                }

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

            case .getUserResult(.success(let user)):
                state.user = user
                return .none

            case .getUserResult(.failure):
                return .none

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
