//
//  VideoApi.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 11.12.21.
//

import AutoVliveApi
import Foundation

class VideoApi: ApiAuthorized {
    // MARK: Internal

    class func getVideoStatus(videoId: Int, user: UserAuth) async throws -> VideoInfoDTO {
        try await withCheckedThrowingContinuation { cont in
            getVideoStatusWithRequestBuilder(videoId: videoId, user: user).execute(AutoVliveApiAPI.apiResponseQueue) {
                Api.throwingParse($0, cont)
            }
        }
    }

    @discardableResult class func playVideo(videoId: Int, viewCount: Int, user: UserAuth) async throws -> MessageResponseDTO {
        try await withCheckedThrowingContinuation { cont in
            playVideoWithRequestBuilder(videoId: videoId, viewCount: viewCount, user: user).execute(AutoVliveApiAPI.apiResponseQueue) {
                Api.throwingParse($0, cont)
            }
        }
    }

    // MARK: Private

    private class func getVideoStatusWithRequestBuilder(videoId: Int, user: UserAuth) -> RequestBuilder<VideoInfoDTO> {
        let builder = VideoClientAPI.getVideoStatusWithRequestBuilder(videoId: videoId)
        return enrich(requestBuilder: builder, auth: user.auth)
    }

    private class func playVideoWithRequestBuilder(videoId: Int, viewCount: Int, user: UserAuth) -> RequestBuilder<MessageResponseDTO> {
        let builder = VideoClientAPI.playVideoWithRequestBuilder(videoId: videoId, viewCount: viewCount)
        return enrich(requestBuilder: builder, auth: user.auth)
    }
}
