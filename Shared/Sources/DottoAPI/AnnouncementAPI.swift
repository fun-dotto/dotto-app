//
//  AnnouncementAPI.swift
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

protocol AnnouncementAPIProtocol {
    func getAnnouncements() async throws -> [Announcement]
}

public final actor AnnouncementAPIImplementation: AnnouncementAPIProtocol {
    private let client: Client

    public init(environment: APIEnvironment, firebaseHelper: FirebaseHelperProtocol) {
        self.client = Client.build(environment: environment, firebaseHelper: firebaseHelper)
    }

    /// Fetches the announcements.
    public func getAnnouncements() async throws -> [Announcement] {
        let response = try await client.announcementsV1List()

        switch response {
        case .ok(let okResponse):
            switch okResponse.body {
            case .json(let jsonBody):
                return jsonBody.announcements.compactMap {
                    guard let url = URL(string: $0.url) else {
                        print("Invalid URL: \($0.url)")
                        return nil
                    }
                    return Announcement(
                        id: $0.id,
                        title: $0.title,
                        date: $0.date,
                        url: url
                    )
                }
            }

        case .unauthorized(_):
            throw DomainError.unauthorized

        case .undocumented(_, _):
            throw DomainError.unknown
        }
    }
}
