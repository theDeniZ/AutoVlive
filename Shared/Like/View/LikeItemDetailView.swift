//
//  LikeItemDetailView.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 12.12.21.
//

import SwiftUI

struct LikeItemDetailView: View {
    // MARK: Lifecycle

    init(likeJob: LikeJob) {
        self.likeJob = likeJob
        videoService = VideoService(video: likeJob.video, isLive: likeJob.isLive, user: UserApiAccessor.shared.currentUser!)
    }

    // MARK: Internal

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.likeService) var likeService: LikeService

    @ObservedObject var likeJob: LikeJob
    @ObservedObject var videoService: VideoService

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Status")) {
                    HStack {
                        Spacer()
                        Text(likeJob.status.description)
                        Spacer()
                        Image(systemName: likeJob.status.systemImageName)
                            .imageScale(.large)
                        Spacer()
                    }.padding(5)

                    HStack {
                        Spacer()
                        Image(systemName: "heart")
                        Text(likeJob.likesPosted.shortFormattedString)
                            .font(.headline)

                        Spacer()

                        Image(systemName: "heart.fill")
                        Text(videoService.videoEmotions.likeCount.shortFormattedString)
                            .font(.headline)

                        Spacer()
                    }

                    HStack {
                        Spacer()

                        Image(systemName: "speedometer")
                        Text(likeJob.velocity)
                            .font(.subheadline)

                        Spacer()
                    }
                }

                Section(header: Text("Actions")) {
                    ForEach([LikeJobStatus.fog, .wind, .snow, .thunder, .idle]) { status in
                        HStack {
                            Spacer()
                            Button {
                                likeService.request(weather: status, for: likeJob)
                            } label: {
                                HStack {
                                    Text("Make it ")
                                    Image(systemName: status.systemImageName)
                                        .imageScale(.large)
                                }
                                .padding(5)
                            }
                            .disabled(status == .thunder && !SettingsHandler.shared.thunderAvailable)
                            Spacer()
                        }
                    }
                }

                Section(header: Text("Archive")) {
                    HStack {
                        Spacer()
                        Button {
                            deleteLikeJob()
                        } label: {
                            HStack {
                                Text("Archive it")
                                    .foregroundColor(.red)
                                Image(systemName: "archivebox")
                                    .imageScale(.large)
                                    .foregroundColor(.red)
                            }
                            .padding(5)
                        }
                        Spacer()
                    }
                }
            }

            Spacer()
        }
        .navigationTitle(likeJob.title)
        .onAppear {
            videoService.startTask()
            videoService.setLiveWatcherDelegate(delegate: self)
        }
        .onDisappear {
            videoService.stopTask()
        }
    }

    // MARK: Private

    private func deleteLikeJob() {
        try? likeService.remove(likeJob: likeJob)
        presentationMode.wrappedValue.dismiss()
    }
}

extension LikeItemDetailView: LiveWatcherDelegate {
    func liveEnded(video: Int) {
        guard likeJob.video == video else {
            print("live \(video) ended, but something is wrong, i can feel it")
            return
        }
        print("stopping like job \(video)")
        likeService.request(weather: .idle, for: likeJob)
    }
}

struct LikeItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LikeItemDetailView(likeJob: LikeJob(title: "test", video: 123, isLive: false))
            .environment(\.likeService, .preview)
    }
}
