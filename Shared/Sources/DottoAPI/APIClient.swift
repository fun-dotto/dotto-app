//
//  APIClient.swift
//  Shared
//
//  Created by Kanta Oikawa on 2026/04/11.
//

import DottoModel
import Foundation
import OpenAPIRuntime
#if os(Android)
import OpenAPIAsyncHTTPClient
#else
import OpenAPIURLSession
#endif

extension Client {
    static func build(environment: APIEnvironment, firebaseHelper: FirebaseHelperProtocol) -> Client {
        let url: URL
        switch environment {
        case .prod:
            url = try! Servers.Server5.url()
        case .qa:
            url = try! Servers.Server4.url()
        case .stg:
            url = try! Servers.Server3.url()
        case .dev:
            url = try! Servers.Server2.url()
        }
        return Client(
            serverURL: url,
            configuration: .init(dateTranscoder: .iso8601),
            transport: makeTransport(),
            middlewares: [APIAuthMiddleware(firebaseHelper: firebaseHelper)]
        )
    }

    private static func makeTransport() -> some ClientTransport {
#if os(Android)
        return AsyncHTTPClientTransport(configuration: .init())
#else
        return URLSessionTransport()
#endif
    }
}
