//
//  LikeView.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 13.12.21.
//

import SwiftUI

struct LikeView: View {
    @Environment(\.likeHistoryStorage) var likeHistoryStorage: LikeHistoryStorage
    @Environment(\.likeService) var likeService: LikeService

    var body: some View {
        InternalLikeView(likeService: likeService, likeHistoryStorage: likeHistoryStorage)
    }
}

private struct InternalLikeView: View {
    @ObservedObject var likeService: LikeService
    @ObservedObject var likeHistoryStorage: LikeHistoryStorage

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Ongoing")) {
                    ForEach(likeService.likeJobs) { likeJob in
                        EmptyNavigationLink {
                            LikeItemDetailView(likeJob: likeJob)
                        } label: {
                            LikeItemView(likeJob: likeJob)
                        }
                        .listRowSeparator(.hidden)
                    }
                }

                Section(header: Text("History")) {
                    ForEach(likeHistoryStorage.history) { item in
                        LikeHistoryItemView(history: item)
                            .listRowSeparator(.hidden)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Like Jobs")
            .navigationBarItems(trailing: HStack {
                Button(action: {
                    Task {
                        await likeHistoryStorage.syncToServer()
                    }
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .imageScale(.large)
                })
                .padding()

                Button(action: {
                    Task {
                        await likeHistoryStorage.syncFromServer()
                    }
                }, label: {
                    Image(systemName: "square.and.arrow.down")
                        .imageScale(.large)
                })
                .padding()
            })
        }
    }
}

struct LikeView_Previews: PreviewProvider {
    static var previews: some View {
        let likeService: LikeService = .preview
        try? likeService.create(likeJob: LikeJob(title: "First like job", video: 0, isLive: false))
        try? likeService.create(likeJob: LikeJob(title: "Second", video: 1, isLive: false))
        try? likeService.create(likeJob: LikeJob(title: "Last like job with a very long title", video: 2, isLive: false))
        return LikeView()
            .environment(\.likeService, likeService)
    }
}
