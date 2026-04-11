//
//  DottoUser.swift
//  Shared
//
//  Created by Kanta Oikawa on 2026/04/11.
//

import Foundation

public struct DottoUser: Hashable, Sendable {
    public let id: String
    public let name: String
    public let email: String
    public let avatarURL: URL?

    public init(id: String, name: String, email: String, avatarURL: URL?) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarURL = avatarURL
    }
}
