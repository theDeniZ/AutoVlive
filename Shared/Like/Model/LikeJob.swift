//
//  LikeJob.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 26.12.21.
//

import Foundation

class LikeJob: ObservableObject, Hashable, Equatable, Identifiable {
    // MARK: Lifecycle

    init(title: String, video: Int, isLive: Bool) {
        self.title = title
        self.video = video
        self.isLive = isLive
    }

    // MARK: Internal

    let video: Int
    let title: String
    let isLive: Bool
    @Published var status: LikeJobStatus = .new
    @Published var likesPosted: Int = 0
    @Published var velocity = "0/min"

    var id: Int {
        video
    }

    static func == (lhs: LikeJob, rhs: LikeJob) -> Bool {
        lhs.video == rhs.video
    }

    func hash(into hasher: inout Hasher) {
        video.hash(into: &hasher)
    }
}

enum LikeJobStatus: Hashable, Identifiable {
    case new
    case idle
    case fog
    case wind
    case snow
    case thunder

    // MARK: Internal

    var description: String {
        switch self {
        case .new: return "New"
        case .idle: return "Idle"
        case .fog: return "Fogy"
        case .wind: return "Windy"
        case .snow: return "Snowy"
        case .thunder: return "Thunder"
        }
    }

    var systemImageName: String {
        switch self {
        case .new: return "plus.circle"
        case .idle: return "moon.stars"
        case .fog: return "cloud.fog"
        case .wind: return "wind"
        case .snow: return "cloud.snow"
        case .thunder: return "cloud.bolt.rain"
        }
    }

    var id: String {
        description
    }
}
