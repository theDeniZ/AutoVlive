//
//  UserDTO.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import Foundation
#if canImport(AnyCodable)
    import AnyCodable
#endif

public struct InternalUserDTO: Codable, Hashable {
    // MARK: Lifecycle

    public init(userId: String, userAuth: String) {
        self.userId = userId
        self.userAuth = userAuth
    }

    // MARK: Public

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case userId
        case userAuth
    }

    public var userId: String
    public var userAuth: String

    // Encodable protocol methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(userAuth, forKey: .userAuth)
    }
}
