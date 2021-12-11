//
//  LikeJobVelocityCalculator.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 24.12.21.
//

import Foundation

class LikeJobVelocityCalculator {
    // MARK: Lifecycle

    init(likeJob: LikeJob) {
        self.likeJob = likeJob
    }

    // MARK: Internal

    let likeJob: LikeJob

    func startJob() {
        amountHistory = []
        velocityTask?.cancel()
        velocityTask = Task(priority: .medium) {
            await startCalculatingVelocity()
        }
    }

    func stopJob() {
        velocityTask?.cancel()
    }

    // MARK: Private

    private var amountHistory = [Int]()

    private var velocityTask: Task<Void, Never>?

    private func startCalculatingVelocity() async {
        while !Task.isCancelled {
            amountHistory.append(likeJob.likesPosted)
            if amountHistory.count > 25 {
                amountHistory.remove(at: 0)
            }
            let averageDifference = amountHistory.differencesArray.average
            DispatchQueue.main.async { [weak self] in
                self?.likeJob.velocity = "\(averageDifference * 12)/min"
            }
            Thread.sleep(forTimeInterval: 5)
        }
    }
}

extension Array where Element == Int {
    /// The average value of all the items in the array
    var average: Int {
        if isEmpty {
            return 0
        } else {
            let sum = reduce(0, +)
            return sum / count
        }
    }

    var differencesArray: [Int] {
        if isEmpty {
            return []
        } else if count == 1 {
            return [self[0]]
        } else {
            var result = [Int]()
            for i in 1 ..< count {
                result.append(self[i] - self[i - 1])
            }
            return result
        }
    }
}
