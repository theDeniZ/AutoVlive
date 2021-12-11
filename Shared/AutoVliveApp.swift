//
//  AutoVliveApp.swift
//  Shared
//
//  Created by DeniZ Dobanda on 11.12.21.
//

import AutoVliveClientApi
import SwiftUI

@main
struct AutoVliveApp: App {
    // MARK: Lifecycle

    init() {
        AutoVliveClientApiAPI.requestBuilderFactory = DigestedRequestBuilderFactory()
        AutoVliveClientApiAPI.apiResponseQueue = DispatchQueue.global(qos: .userInteractive)
        AutoVliveClientApiAPI.credential = URLCredential(user: "", password: "", persistence: .forSession)

        let userStorage = UserStorage(context: persistenceController.container.newBackgroundContext())
        UserStorage.shared = userStorage
        _userStorage = StateObject(wrappedValue: userStorage)

        let likeHistoryStorage = LikeHistoryStorage(context: persistenceController.container.newBackgroundContext())
        LikeHistoryStorage.shared = likeHistoryStorage
        _likeHistoryStorage = StateObject(wrappedValue: likeHistoryStorage)

        UserApiAccessor.shared = UserApiAccessor(userStorage: userStorage)
        UserApiAccessor.shared.useDefaultUser(userStorage)

        _likeService = StateObject(wrappedValue: LikeService(userStorage))
    }

    // MARK: Internal

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TabNavigationView()
                .environment(\.userStorage, userStorage)
                .environment(\.likeHistoryStorage, likeHistoryStorage)
                .environment(\.likeService, likeService)
                .task {
                    NotificationManager.shared.start()
                }
        }
    }

    // MARK: Private

    @StateObject private var userStorage: UserStorage
    @StateObject private var likeHistoryStorage: LikeHistoryStorage
    @StateObject private var likeService: LikeService
}
