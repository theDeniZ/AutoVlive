//
//  TaskService.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 25.12.21.
//

import Foundation

class TaskService {
    // MARK: Lifecycle

    deinit {
        task?.cancel()
    }

    // MARK: Internal

    func startTask() {
        stopTask()
        task = Task(priority: .medium) {
            await performTask()
        }
    }

    func stopTask() {
        task?.cancel()
    }

    internal func performTask() async {}

    // MARK: Private

    private var task: Task<Void, Never>?
}
