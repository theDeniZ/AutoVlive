//
//  ActiveUserVideoService.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 23.12.21.
//

import AutoVliveApi
import Foundation

struct ActiveLikeHistory {
    let amount: Int
    let date: Date
}

actor PostedLikesHistrory {
    // MARK: Internal

    func getHistory(for userName: String) -> [ActiveLikeHistory] {
        postedLikesHistory[userName] ?? []
    }

    func set(history: [ActiveLikeHistory], for userName: String) {
        postedLikesHistory[userName] = history
    }

    func addHistory(for userName: String, amount: Int) {
        var history = getHistory(for: userName)
        history.append(ActiveLikeHistory(amount: amount, date: Date.now))
        set(history: history, for: userName)
    }

    func clearHistory(for userName: String, clearingAllEntriesOlderThanSeconds: Double) {
        let history = getHistory(for: userName)
        let now = Date.now
        let filtered = history.filter { $0.date.distance(to: now).isLess(than: clearingAllEntriesOlderThanSeconds) }
        set(history: filtered, for: userName)
    }

    // MARK: Private

    private var postedLikesHistory: [String: [ActiveLikeHistory]] = [:]
}

class ActiveUserVideoService {
    // MARK: Lifecycle

    init(videoId: Int) {
        self.videoId = videoId
    }

    // MARK: Internal

    func isActive(user: UserAuth) async -> Bool {
        await postedLikesHistory.clearHistory(for: user.name, clearingAllEntriesOlderThanSeconds: amountOfSecondsBeforeInactive)
        let allPostedLikesAmount = await getAllPostedLikesAmount(userName: user.name)
        return maxAmountOfLikesInTheTimeInterval > allPostedLikesAmount
    }

    func postLikes(amount: Int, user: UserAuth) async throws -> Like? {
        guard await isActive(user: user) else { return nil }
        let allowedAmount = await getAllowedLikesAmount(for: user, askedFor: amount)
        let like = try await likeApi.postLike(count: allowedAmount, videoSeq: videoId, user: user)
        await postedLikesHistory.addHistory(for: user.name, amount: allowedAmount)
        return like
    }

    // MARK: Private

    private let amountOfSecondsBeforeInactive: Double = 60 * 2
    private let maxAmountOfLikesInTheTimeInterval = 980

    private let videoId: Int
    private let likeApi = FastLikeApi.self

    private let postedLikesHistory = PostedLikesHistrory()

    // MARK: - Private helpers

    private func getAllPostedLikesAmount(userName: String) async -> Int {
        let history = await postedLikesHistory.getHistory(for: userName)
        return history.reduce(0) { $0 + $1.amount }
    }

    private func getMacAllowedAmountOfLikesToPost(userName: String) async -> Int {
        let postedAmount = await getAllPostedLikesAmount(userName: userName)
        return maxAmountOfLikesInTheTimeInterval - postedAmount
    }

    private func getAllowedLikesAmount(for user: UserAuth, askedFor amount: Int) async -> Int {
        let maxAmount = await getMacAllowedAmountOfLikesToPost(userName: user.name)
        return min(maxAmount, amount)
    }
}
