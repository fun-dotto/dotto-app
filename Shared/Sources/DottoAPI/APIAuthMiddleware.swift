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
        var request = request
        do {
            let appCheckToken = try await firebaseHelper.getAppCheckToken()
            request.headerFields.append(
                .init(
                    name: .init("X-Firebase-AppCheck")!, value: appCheckToken
                ))
        } catch {
            print("Failed to get App Check token: \(error)")
        }
        do {
            let idToken = try await firebaseHelper.getUserIDToken()
            request.headerFields[.authorization] = "Bearer \(idToken)"
        } catch {
            print("Failed to get ID token: \(error)")
        }
        return try await next(request, body, baseURL)
    }
}
