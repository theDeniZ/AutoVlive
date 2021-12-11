//
//  VideoService.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import AutoVliveApi
import Foundation

protocol LiveWatcherDelegate {
    func liveEnded(video: Int)
}

class VideoService: TaskService, ObservableObject {
    // MARK: Lifecycle

    internal init(video: Int, isLive: Bool, user: UserAuth) {
        self.video = video
        self.isLive = isLive
        self.user = user
        videoWatchService = VideoWatchService(isLive: isLive, videoId: video)
    }

    // MARK: Public

    public func setLiveWatcherDelegate(delegate: LiveWatcherDelegate) {
        liveWatcherDelegate = delegate
    }

    // MARK: Internal

    @Published var videoEmotions: Emotions = .empty

    static func create(video: Int, isLive: Bool, user: UserAuth) -> VideoService {
        let service = VideoService(video: video, isLive: isLive, user: user)
        return service
    }

    override internal func performTask() async {
        guard !Task.isCancelled else { return }
        await playVideo()
        await updateStatus()
    }

    // MARK: Private

    private let isLive: Bool
    private let video: Int
    private let user: UserAuth
    private var playedVideoAlready = false

    private let videoWatchService: VideoWatchService
    private var liveWatcherDelegate: LiveWatcherDelegate?

    private func playVideo() async {
        guard !Task.isCancelled, !playedVideoAlready else { return }
        await videoWatchService.watch(with: [user])
        playedVideoAlready = true
    }

    private func updateStatus() async {
        guard !Task.isCancelled else { return }
        await isLive ? updateLiveStatus() : updateVideoStatus()
    }

    private func updateVideoStatus() async {
        guard !Task.isCancelled else { return }
        do {
            let status = try await VideoApi.getVideoStatus(videoId: video, user: user)
            let emotions = status.emotions
            guard !Task.isCancelled else { return }
            DispatchQueue.main.async {
                self.videoEmotions = emotions
            }
        } catch {
            guard !Task.isCancelled else { return }
            DispatchQueue.main.async {
                self.videoEmotions = .empty
            }
        }
    }

    private func updateLiveStatus() async {
        guard !Task.isCancelled else { return }
        do {
            let status = try await LiveApi.getLiveStatus(liveId: video, user: user)
            if status.status == .ended {
                DispatchQueue.main.async {
                    self.liveWatcherDelegate?.liveEnded(video: self.video)
                }
                stopTask()
            }
            let emotions = status.emotions
            guard !Task.isCancelled else { return }
            DispatchQueue.main.async {
                self.videoEmotions = emotions
            }
        } catch {
            guard !Task.isCancelled else { return }
            DispatchQueue.main.async {
                self.videoEmotions = .empty
            }
        }
        Thread.sleep(forTimeInterval: 5)
        await updateLiveStatus()
    }
}
