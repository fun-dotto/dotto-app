//
//  DottoAPIFirebaseHelper.swift
//  Dotto
//
//  Created by Kanta Oikawa on 2026/04/11.
//

import DottoModel
import DottoAPI
import FirebaseAppCheck
import FirebaseAuth

final actor DottoAPIFirebaseHelper: FirebaseHelperProtocol {
    func getAppCheckToken() async throws -> String {
        let appCheckToken = try await AppCheck.appCheck().token(forcingRefresh: false)
        return appCheckToken.token
    }

    func getUserIDToken() async throws -> String {
        guard let user = Auth.auth().currentUser else {
            throw DomainError.unauthenticated
        }
        return try await user.getIDToken(forcingRefresh: false)
    }
}
