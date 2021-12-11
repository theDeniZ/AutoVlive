//
//  VideoFeedDetailView.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import AutoVliveApi
import SwiftUI

struct VideoFeedDetailView: View {
    // MARK: Lifecycle

    init(video: VideoFeedItem) {
        self.video = video

        likeJob = LikeJob(
            title: video.title,
            video: video.id,
            isLive: video.isLive
        )
    }

    // MARK: Internal

    let video: VideoFeedItem

    var body: some View {
        VStack {
            if video.isLive {
                Text("LIVE")
                    .foregroundColor(.red)
            }

            if let thumbnail = video.thumbnail {
                CachedImage(url: thumbnail)
            }

            HStack {
                VStack(alignment: .leading) {
                    Text(video.author)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(video.title)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(3)

                    EmotionsInfoBar(video: video)

                    Text(video.creationDate, formatter: .dateFormatter)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .layoutPriority(100)

                Spacer()
            }
            .padding()
        }
        .padding([.top, .horizontal])
        .navigationTitle(video.title)
        .navigationBarItems(trailing: HStack {
            switch likeJobStatus {
            case .new:
                Button {
                    postLikeJob()
                } label: {
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                }
                .padding()
            default:
                Image(systemName: likeJobStatus.systemImageName)
                    .imageScale(.large)
                    .padding()
            }
        })
    }

    // MARK: Private

    @Environment(\.likeService) private var likeService: LikeService

    @ObservedObject private var likeJob: LikeJob

    private var likeJobStatus: LikeJobStatus {
        likeService.getLikeJob(forVideo: likeJob.video)?.status ?? .new
    }

    private func postLikeJob() {
        try? likeService.create(likeJob: likeJob)
    }
}

struct VideoFeedDetailView_Previews: PreviewProvider {
    static var previews: some View {
        VideoFeedDetailView(video: .empty)
    }
}
