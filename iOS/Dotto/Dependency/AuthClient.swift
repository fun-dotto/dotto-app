//
//  AuthClient.swift
//  Dotto
//
//  Created by Kanta Oikawa on 2026/04/11.
//

import Dependencies
import DependenciesMacros
import DottoModel
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import SwiftUI

@DependencyClient
struct AuthClient {
    var signIn: @Sendable (_ viewController: UIViewController) async throws -> DottoUser
    var signOut: @Sendable () async throws -> Void
}

extension AuthClient: TestDependencyKey {
    static let previewValue = AuthClient(
        signIn: { _ in
            DottoUser(
                id: "dotto-user",
                name: "Dotto User",
                email: "dottouser@fun.ac.jp",
                avatarURL: nil
            )
        },
        signOut: {
        }
    )

    static let testValue = AuthClient()
}

extension DependencyValues {
    var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}

extension AuthClient: DependencyKey {
    static let liveValue = AuthClient(
        signIn: { viewController in
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                throw DomainError.failedToAuthenticate
            }
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
            let gidUser = gidSignInResult.user
            guard let idToken = gidUser.idToken?.tokenString else {
                throw DomainError.failedToAuthenticate
            }
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: gidUser.accessToken.tokenString
            )
            let firebaseAuthDataResult = try await Auth.auth().signIn(with: credential)
            let firebaseUser = firebaseAuthDataResult.user
            return DottoUser(
                id: firebaseUser.uid,
                name: firebaseUser.displayName ?? "",
                email: firebaseUser.email ?? "",
                avatarURL: firebaseUser.photoURL
            )
        },
        signOut: {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
        }
    )
}
