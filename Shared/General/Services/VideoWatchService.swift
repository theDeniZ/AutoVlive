//
//  VideoWatchService.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 23.12.21.
//

import AutoVliveApi
import Foundation

struct VideoWatchService {
    // MARK: Internal

    let isLive: Bool
    let videoId: Int

    func watch(with users: [UserAuth]) async {
        if isLive {
            await watchLive(with: users)
        } else {
            await watchVideo(with: users)
        }
    }

    // MARK: Private

    private func watchVideo(with users: [UserAuth]) async {
        await withTaskGroup(of: Void.self) { taskGroup in
            users.forEach { user in
                taskGroup.addTask {
                    guard !Task.isCancelled else { return }
                    _ = try? await VideoApi.playVideo(videoId: videoId, viewCount: 1, user: user)
                }
            }
        }
    }

    private func watchLive(with users: [UserAuth]) async {
        await withTaskGroup(of: Void.self) { taskGroup in
            users.forEach { user in
                taskGroup.addTask {
                    guard !Task.isCancelled else { return }
                    _ = try? await LiveApi.joinLive(liveId: videoId, viewCount: 1, user: user)
                }
            }
        }
    }
}
