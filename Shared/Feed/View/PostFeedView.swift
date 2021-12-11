//
//  PostFeedView.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import AutoVliveApi
import SwiftUI

struct PostFeedView: View {
    let post: PostFeedItem

    var body: some View {
        VStack {
            if let thumbnail = post.thumbnails.first {
                CachedImage(url: thumbnail)
            }

            HStack {
                VStack(alignment: .leading) {
                    Text(post.author)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(post.title)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(3)
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
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray.opacity(0.2), lineWidth: 2)
        )
        .padding([.top, .horizontal])
    }
}

struct PostFeedView_Previews: PreviewProvider {
    static var previews: some View {
        PostFeedView(post: .empty)
    }
}
