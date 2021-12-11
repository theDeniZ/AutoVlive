//
//  VideoFeedView.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import AutoVliveApi
import SwiftUI

struct VideoFeedView: View {
    // MARK: Internal

    let video: VideoFeedItem

    var body: some View {
        VStack {
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

                    EmotionsInfoBar(video: video, loading: false)

                    Text(video.creationDate, formatter: .dateFormatter)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .layoutPriority(100)

                Spacer()
            }
            .padding()
        }
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(overlayColor, lineWidth: 2))
        .padding([.top, .horizontal])
    }

    // MARK: Private

    private var overlayColor: Color {
        video.isLive ? .red.opacity(0.5) : .gray.opacity(0.2)
    }
}

struct VideoFeedView_Previews: PreviewProvider {
    static var previews: some View {
        VideoFeedView(video: .empty)
    }
}
