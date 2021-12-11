//
//  PostFeedDetailView.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import AutoVliveApi
import SwiftUI

struct PostFeedDetailView: View {
    let post: PostFeedItem

    var body: some View {
        ScrollView {
            ImageGallery(images: post.thumbnails.map { .init(id: $0.absoluteString, url: $0) })
                .frame(minHeight: 300, maxHeight: 500)

            HStack {
                VStack(alignment: .leading) {
                    Text(post.author)
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Spacer()

                    Text(post.body)
                        .foregroundColor(.primary)

                    Spacer()

                    HStack {
                        Image(systemName: "heart")
                            .foregroundColor(.secondary)
                        Text(post.likeCount.shortFormattedString)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Spacer()

                        Image(systemName: "message")
                            .foregroundColor(.secondary)
                        Text(post.commentCount.shortFormattedString)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Text(post.creationDate, formatter: .dateFormatter)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .layoutPriority(100)

                Spacer()
            }
            .padding()
        }
        .padding([.top, .horizontal])
        .navigationTitle(post.title)
    }
}

struct FeedPostItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostFeedDetailView(post: .empty)
    }
}
