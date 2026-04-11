//
//  APIAuthMiddleware.swift
//  Shared
//
//  Created by Kanta Oikawa on 2026/04/11.
//

import Foundation
import HTTPTypes
import OpenAPIRuntime

final class APIAuthMiddleware: ClientMiddleware, @unchecked Sendable {
    private let firebaseHelper: FirebaseHelperProtocol

    init(firebaseHelper: FirebaseHelperProtocol) {
        self.firebaseHelper = firebaseHelper
    }

    func intercept(
        _ request: HTTPTypes.HTTPRequest,
        body: OpenAPIRuntime.HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @Sendable (HTTPTypes.HTTPRequest, OpenAPIRuntime.HTTPBody?, URL) async throws -> (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?)
    ) async throws -> (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?) {
        let appCheckToken = try await firebaseHelper.getAppCheckToken()
        let idToken = try await firebaseHelper.getUserIDToken()
        var request = request
        request.headerFields.append(
            .init(
                name: .init("X-Firebase-AppCheck")!, value: appCheckToken
            ))
        request.headerFields[.authorization] = "Bearer \(idToken)"
        return try await next(request, body, baseURL)
    }
}
