//
//  LikeInfoBar.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 18.12.21.
//

import AutoVliveApi
import SwiftUI

extension Emotions: Identifiable {
    public var id: Int {
        playCount + likeCount + commentCount
    }
}

struct EmotionsInfoBar: View {
    // MARK: Lifecycle

    init(video: VideoFeedItem, loading: Bool = true) {
        videoService = VideoService.create(
            video: video.id,
            isLive: video.isLive,
            user: UserApiAccessor.shared.currentUser!
        )
        self.loading = loading
        if !loading {
            videoService.videoEmotions = video.videoEmotions
        }
    }

    // MARK: Internal

    var body: some View {
        HStack {
            Image(systemName: "play")
                .foregroundColor(.secondary)
            Text("\(videoService.videoEmotions.playCount)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()

            Image(systemName: "heart")
                .foregroundColor(.secondary)
            Text("\(videoService.videoEmotions.likeCount)")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()

            Image(systemName: "message")
                .foregroundColor(.secondary)
            Text("\(videoService.videoEmotions.commentCount)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .onAppear {
            guard loading else { return }
            videoService.startTask()
        }
        .onDisappear {
            videoService.stopTask()
        }
    }

    // MARK: Private

    @ObservedObject private var videoService: VideoService
    private var loading: Bool
}

struct LikeInfoBar_Previews: PreviewProvider {
    static var previews: some View {
        EmotionsInfoBar(video: .empty)
    }
}
