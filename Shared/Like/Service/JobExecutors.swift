//
//  JobExecutors.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 21.12.21.
//

import AutoVliveApi
import SwiftUI

class BaseJobExecutor: LikeJobExecutable {
    // MARK: Lifecycle

    required init(
        likeJob: LikeJob,
        userStorage: UserStorage,
        activeUserVideoService: ActiveUserVideoService,
        userInitService: UserInitService
    ) {
        self.likeJob = likeJob
        self.userStorage = userStorage
        self.activeUserVideoService = activeUserVideoService
        self.userInitService = userInitService
        velocityCalculator = LikeJobVelocityCalculator(likeJob: likeJob)
    }

    // MARK: Internal

    static func create(
        likeJob: LikeJob,
        userStorage: UserStorage,
        activeUserVideoService: ActiveUserVideoService,
        userInitService: UserInitService
    ) -> LikeJobExecutable {
        Self(likeJob: likeJob, userStorage: userStorage, activeUserVideoService: activeUserVideoService, userInitService: userInitService)
    }

    func startJob() {
        IdleService.addBackgroundJob()
        velocityCalculator.startJob()
    }

    func stopJob() {
        IdleService.removeBackgroundJob()
        velocityCalculator.stopJob()
    }

    // MARK: Fileprivate

    fileprivate let likeJob: LikeJob
    fileprivate let userStorage: UserStorage
    fileprivate let activeUserVideoService: ActiveUserVideoService
    fileprivate let userInitService: UserInitService
    fileprivate var task: Task<Void, Never>?

    fileprivate func increment(by like: Like) {
        DispatchQueue.main.async {
            self.likeJob.likesPosted += like.amount
        }
    }

    // MARK: Private

    private let velocityCalculator: LikeJobVelocityCalculator
}

class BackgrounodJobExecutor: BaseJobExecutor {
    // MARK: Lifecycle

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: Internal

    override func startJob() {
        super.startJob()
        startBackgroundJob()
    }

    override func stopJob() {
        super.stopJob()
        backgroundTaskWasRunning = false
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }

    // MARK: Fileprivate

    fileprivate func startBackgroundJob() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(
            self, selector: #selector(reinstateBackgroundTask),
            name: UIApplication.didBecomeActiveNotification, object: nil
        )

        backgroundTaskWasRunning = true
        registerBackgroundTask()
    }

    // MARK: Private

    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var backgroundTaskWasRunning = false

    private func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            let original = self?.backgroundTaskWasRunning ?? false
            self?.stopJob()
            self?.backgroundTaskWasRunning = original
            NotificationManager.shared.sendNotification()
        }
        assert(backgroundTask != .invalid)
    }

    @objc private func reinstateBackgroundTask() {
        if backgroundTask == .invalid, backgroundTaskWasRunning {
            startJob()
        }
    }
}

class FogJobExecutor: BackgrounodJobExecutor {
    // MARK: Internal

    override func startJob() {
        super.startJob()
        task = Task(priority: .high) {
            await postLikes()
        }
    }

    override func stopJob() {
        super.stopJob()
        task?.cancel()
    }

    // MARK: Fileprivate

    fileprivate var userLikePostAmount: Int { 10 }
    fileprivate var userLikePostRepeatingCycles: Int { 7 }

    fileprivate func postLikes() async {
        guard !Task.isCancelled else { return }

        var users = await getActiveUsers(excluding: [])
        var usersRainedWith = [UserAuth]()

        while users.isEmpty, !Task.isCancelled {
            print("Whoops, there are no active users now: \(Date.now). Job: \(self.self)")
            sleep(5)
            users = await getActiveUsers(excluding: [])
        }

        while !users.isEmpty, !Task.isCancelled {
            userInitService.initialize(users: users)

            for likeIndex in 0 ..< userLikePostRepeatingCycles {
                await sendLikes(with: users, id: likeIndex)
            }

            usersRainedWith.append(contentsOf: users)
            users = await getActiveUsers(excluding: usersRainedWith)
        }

        if !Task.isCancelled {
            await postLikes()
        }
    }

    fileprivate func sendLikes(with users: [UserAuth], id _: Int) async {
        guard !Task.isCancelled else { return }
        let amount = userLikePostAmount
        await withTaskGroup(of: Like?.self) { group in
            users.forEach { user in
                group.addTask {
                    guard !Task.isCancelled else { return nil }
                    do {
                        return try await self.activeUserVideoService.postLikes(amount: amount, user: user)
                    } catch {
                        print("User \(user.name) like \(amount) failed: \(error.localizedDescription)")
                        return nil
                    }
                }
            }

            for await result in group {
                result.flatMap(increment(by:))
            }
        }
    }

    fileprivate func getActiveUsers(excluding excludedUsers: [UserAuth] = []) async -> [UserAuth] {
        guard !Task.isCancelled else { return [] }
        return await userStorage.getUsers { user in
            guard !excludedUsers.contains(user) else { return false }
            return await activeUserVideoService.isActive(user: user)
        }
    }
}

class WindJobExecutor: FogJobExecutor {
    override fileprivate var userLikePostAmount: Int { 25 }
    override fileprivate var userLikePostRepeatingCycles: Int { 14 }
}

class SnowJobExecutor: WindJobExecutor {
    override fileprivate var userLikePostAmount: Int { 49 }
    override fileprivate var userLikePostRepeatingCycles: Int { 20 }
}

class ThunderJobExecutor: SnowJobExecutor {
    // MARK: Internal

    override func startJob() {
        fatalError()
    }

    func makeThunder() async {
        await postLikes()
    }

    // MARK: Fileprivate

    override fileprivate func postLikes() async {
        guard !Task.isCancelled else { return }

        let users = await getActiveUsers(excluding: [])
        userInitService.initialize(users: users)

        for likeIndex in 0 ..< userLikePostRepeatingCycles {
            await sendLikes(with: users, id: likeIndex)
        }
    }

    override fileprivate func getActiveUsers(excluding _: [UserAuth] = []) async -> [UserAuth] {
        userStorage.users
    }
}
