//
//  IdleService.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 23.12.21.
//

import SwiftUI

class IdleService {
    // MARK: Internal

    static func addBackgroundJob() {
        if backgroundJobs == 0 {
            UIApplication.shared.isIdleTimerDisabled = true
        }
        backgroundJobs += 1
    }

    static func removeBackgroundJob() {
        backgroundJobs -= 1
        if backgroundJobs == 0 {
            UIApplication.shared.isIdleTimerDisabled = false
        }
    }

    // MARK: Private

    private static var backgroundJobs = 0
}
