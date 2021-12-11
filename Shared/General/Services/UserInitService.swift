//
//  VideoWatchService.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 23.12.21.
//

import Foundation

class UserInitService {
    // MARK: Lifecycle

    internal init(isLive: Bool, videoId: Int) {
        self.isLive = isLive
        self.videoId = videoId
    }

    // MARK: Internal

    let isLive: Bool
    let videoId: Int

    func initialize(users: [UserAuth]) {
        let uninitializedUsers = users.filter { !initializedUsers.contains($0) }
        doInitizlisation(of: uninitializedUsers)
        initializedUsers.append(contentsOf: uninitializedUsers)
    }

    // MARK: Private

    private lazy var videoWatchService = VideoWatchService(isLive: isLive, videoId: videoId)
    private let userLoginService = UserLoginService()

    private var initializedUsers: [UserAuth] = []

    private func doInitizlisation(of users: [UserAuth]) {
        guard !users.isEmpty else { return }
        Task {
            await userLoginService.login(with: users)
            await videoWatchService.watch(with: users)
        }
    }
}
