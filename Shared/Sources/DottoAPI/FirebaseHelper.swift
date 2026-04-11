//
//  FirebaseHelperProtocol.swift
//  Shared
//
//  Created by Kanta Oikawa on 2026/04/11.
//

public protocol FirebaseHelperProtocol {
    func getAppCheckToken() async throws -> String

    func getUserIDToken() async throws -> String
}
