//
//  Announcement.swift
//  Shared
//
//  Created by Kanta Oikawa on 2026/04/11.
//

import Foundation

public struct Announcement: Hashable, Identifiable, Sendable {
    public let id: String
    public let title: String
    public let date: Date
    public let url: URL

    public init(id: String, title: String, date: Date, url: URL) {
        self.id = id
        self.title = title
        self.date = date
        self.url = url
    }
}
