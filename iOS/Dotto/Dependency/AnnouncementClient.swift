//
//  AnnouncementClient.swift
//  Dotto
//
//  Created by Kanta Oikawa on 2026/04/12.
//

import Dependencies
import DependenciesMacros
import DottoAPI
import DottoModel
import Foundation

@DependencyClient
struct AnnouncementClient {
    var getAnnouncements: @Sendable () async throws -> [Announcement]
}

extension AnnouncementClient: TestDependencyKey {
    static let previewValue = AnnouncementClient(
        getAnnouncements: {
            [
                Announcement(
                    id: "1",
                    title: "2026年度前期の履修登録について",
                    date: Date(),
                    url: URL(string: "https://example.com/1")!
                ),
                Announcement(
                    id: "2",
                    title: "学生証の更新手続きについて",
                    date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                    url: URL(string: "https://example.com/2")!
                ),
                Announcement(
                    id: "3",
                    title: "キャンパスネットワークメンテナンスのお知らせ",
                    date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                    url: URL(string: "https://example.com/3")!
                ),
            ]
        }
    )

    static let testValue = AnnouncementClient()
}

extension DependencyValues {
    var announcementClient: AnnouncementClient {
        get { self[AnnouncementClient.self] }
        set { self[AnnouncementClient.self] = newValue }
    }
}

extension AnnouncementClient: DependencyKey {
    static let liveValue: AnnouncementClient = {
        let api = AnnouncementAPIImplementation(
            environment: .prod,
            firebaseHelper: DottoAPIFirebaseHelper()
        )
        return AnnouncementClient(
            getAnnouncements: {
                try await api.getAnnouncements()
            }
        )
    }()
}
