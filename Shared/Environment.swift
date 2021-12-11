//
//  Environment.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 22.01.22.
//

import SwiftUI

struct UserStorageEnvironmentKey: EnvironmentKey {
    static var defaultValue = UserStorage()
}

struct LikeHistoryStorageEnvironmentKey: EnvironmentKey {
    static var defaultValue = LikeHistoryStorage()
}

struct LikeServiceEnvironmentKey: EnvironmentKey {
    static var defaultValue = LikeService(UserStorage())
}

extension EnvironmentValues {
    var userStorage: UserStorage {
        get { self[UserStorageEnvironmentKey.self] }
        set { self[UserStorageEnvironmentKey.self] = newValue }
    }

    var likeHistoryStorage: LikeHistoryStorage {
        get { self[LikeHistoryStorageEnvironmentKey.self] }
        set { self[LikeHistoryStorageEnvironmentKey.self] = newValue }
    }

    var likeService: LikeService {
        get { self[LikeServiceEnvironmentKey.self] }
        set { self[LikeServiceEnvironmentKey.self] = newValue }
    }
}
