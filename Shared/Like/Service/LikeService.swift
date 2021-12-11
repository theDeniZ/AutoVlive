//
//  LikeService.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 13.12.21.
//

import Foundation
import SwiftUI

enum LikeServiceError: Error {
    case likeJobDoesNotExists
    case likeJobAlreadyExists
}

class LikeService: ObservableObject {
    // MARK: Lifecycle

    init(_ userStorage: UserStorage) {
        self.userStorage = userStorage
    }

    // MARK: Internal

    @Published var likeJobs: [LikeJob] = []

    let userStorage: UserStorage

    func create(likeJob: LikeJob) throws {
        guard !likeJobs.contains(likeJob) else { throw LikeServiceError.likeJobAlreadyExists }

        let executor = LikeJobExecutor(likeJob: likeJob, userStorage: userStorage)
        executors[likeJob] = executor
        likeJobs.append(likeJob)
        likeJob.status = .idle
    }

    func getLikeJob(forVideo video: Int) -> LikeJob? {
        likeJobs.first(where: { $0.video == video })
    }

    func remove(likeJob: LikeJob) throws {
        guard likeJobs.contains(likeJob) else { throw LikeServiceError.likeJobDoesNotExists }
        executors[likeJob]?.stop()
        executors.removeValue(forKey: likeJob)
        likeJobs.removeAll(where: { $0 == likeJob })
        storeHistory(from: likeJob)
        reset(likeJob: likeJob)
    }

    func request(weather: LikeJobStatus, for likeJob: LikeJob) {
        guard let executor = executors[likeJob] else { return }
        switch weather {
        case .fog: executor.startFog()
        case .wind: executor.startWind()
        case .snow: executor.startSnow()
        case .thunder:
            Task {
                await executor.startThunder()
            }
        case .idle: executor.stop()
        default: break
        }
    }

    func stop(likeJob: LikeJob) {
        executors[likeJob]?.stop()
    }

    // MARK: Private

    private var executors: [LikeJob: LikeJobExecutor] = [:]

    private func storeHistory(from likeJob: LikeJob) {
        guard likeJob.likesPosted > 0 else { return }
        try? LikeHistoryStorage.shared.addHistoryItem(video: likeJob.title, likes: likeJob.likesPosted)
    }

    private func reset(likeJob: LikeJob) {
        likeJob.likesPosted = 0
        likeJob.status = .idle
    }
}

protocol LikeJobExecutable {
    static func create(
        likeJob: LikeJob,
        userStorage: UserStorage,
        activeUserVideoService: ActiveUserVideoService,
        userInitService: UserInitService
    ) -> LikeJobExecutable

    func startJob()

    func stopJob()
}

private class LikeJobExecutor {
    // MARK: Lifecycle

    init(likeJob: LikeJob, userStorage: UserStorage) {
        self.likeJob = likeJob
        self.userStorage = userStorage
        activeUserVideoService = ActiveUserVideoService(videoId: likeJob.video)
        userInitService = UserInitService(isLive: likeJob.isLive, videoId: likeJob.video)
    }

    // MARK: Internal

    func startFog() {
        likeJob.status = .fog
        currentJobExecutor?.stopJob()

        let storm = FogJobExecutor.create(
            likeJob: likeJob,
            userStorage: userStorage,
            activeUserVideoService: activeUserVideoService,
            userInitService: userInitService
        )
        storm.startJob()
        currentJobExecutor = storm
    }

    func startWind() {
        likeJob.status = .wind
        currentJobExecutor?.stopJob()

        let storm = WindJobExecutor.create(
            likeJob: likeJob,
            userStorage: userStorage,
            activeUserVideoService: activeUserVideoService,
            userInitService: userInitService
        )
        storm.startJob()
        currentJobExecutor = storm
    }

    func startSnow() {
        likeJob.status = .snow
        currentJobExecutor?.stopJob()

        let storm = SnowJobExecutor.create(
            likeJob: likeJob,
            userStorage: userStorage,
            activeUserVideoService: activeUserVideoService,
            userInitService: userInitService
        )
        storm.startJob()
        currentJobExecutor = storm
    }

    func startThunder() async {
        let oldStatus = likeJob.status
        DispatchQueue.main.async {
            self.likeJob.status = .thunder
        }

        let storm = ThunderJobExecutor.create(
            likeJob: likeJob,
            userStorage: userStorage,
            activeUserVideoService: activeUserVideoService,
            userInitService: userInitService
        ) as! ThunderJobExecutor
        await storm.makeThunder()

        DispatchQueue.main.async {
            self.likeJob.status = oldStatus
        }
    }

    func stop() {
        currentJobExecutor?.stopJob()
        currentJobExecutor = nil
        likeJob.status = .idle
    }

    // MARK: Private

    private let likeJob: LikeJob
    private let userStorage: UserStorage
    private let activeUserVideoService: ActiveUserVideoService
    private let userInitService: UserInitService

    private var currentJobExecutor: LikeJobExecutable?
}
