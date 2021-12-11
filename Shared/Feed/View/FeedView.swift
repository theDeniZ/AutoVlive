//
//  FeedView.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import AutoVliveApi
import SwiftUI

struct FeedView: View {
    // MARK: Internal

    var body: some View {
        NavigationView {
            List {
                ForEach(feedService.feed) { feedItem in
                    if let post = feedItem as? PostFeedItem {
                        EmptyNavigationLink {
                            PostFeedDetailView(post: post)
                        } label: {
                            PostFeedView(post: post)
                        }
                        .listRowSeparator(.hidden)
                    } else if let video = feedItem as? VideoFeedItem {
                        EmptyNavigationLink {
                            VideoFeedDetailView(video: video)
                        } label: {
                            VideoFeedView(video: video)
                        }
                        .listRowSeparator(.hidden)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Feed of \(userApiAccessor.currentUser?.name ?? "NULL")")
            .refreshable {
                await feedService.performTask()
            }
        }
        .onAppear {
            feedService.startTask()
        }
    }

    // MARK: Private

    @ObservedObject private var feedService = FeedService(usingUserApiAccessor: true)
    @ObservedObject private var userApiAccessor = UserApiAccessor.shared
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
