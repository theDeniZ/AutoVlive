//
//  VideoApi.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 11.12.21.
//

import AutoVliveApi
import Foundation

class LiveApi: ApiAuthorized {
    class func getLiveStatus(liveId: Int, user: UserAuth) async throws -> LiveStatusDTO {
        try await withCheckedThrowingContinuation { cont in
            getLiveStatusWithRequestBuilder(liveId: liveId, user: user).execute(AutoVliveApiAPI.apiResponseQueue) {
                Api.throwingParse($0, cont)
            }
        }
    }

    class func joinLive(liveId: Int, viewCount: Int, user: UserAuth) async throws -> MessageResponseDTO {
        try await withCheckedThrowingContinuation { cont in
            joinLiveWithRequestBuilder(liveId: liveId, viewCount: viewCount, user: user).execute(AutoVliveApiAPI.apiResponseQueue) {
                Api.throwingParse($0, cont)
            }
        }
    }

    class func getLiveCommentsWithRequestBuilder(
        categoryId: String, country: String, lang: String,
        manager: Int, objectId: Int, page: Int, pageSize: Int,
        pool: String, templateId: String,
        ticket: String, transLang: String,
        user: UserAuth
    ) -> RequestBuilder<CommentInfoDTO> {
        let request = LiveClientAPI.getLiveCommentsWithRequestBuilder(categoryId: categoryId, country: country, lang: lang, manager: manager, objectId: objectId, page: page, pageSize: pageSize, pool: pool, templateId: templateId, ticket: ticket, transLang: transLang)
        return enrich(requestBuilder: request, auth: user.auth)
    }

    class func getLiveInfoWithRequestBuilder(liveId: Int, user: UserAuth) -> RequestBuilder<LiveInfoDTO> {
        let request = LiveClientAPI.getLiveInfoWithRequestBuilder(liveId: liveId)
        return enrich(requestBuilder: request, auth: user.auth)
    }

    class func getLiveStatusWithRequestBuilder(liveId: Int, user: UserAuth) -> RequestBuilder<LiveStatusDTO> {
        let request = LiveClientAPI.getLiveStatusWithRequestBuilder(liveId: liveId)
        return enrich(requestBuilder: request, auth: user.auth)
    }

    class func joinLiveWithRequestBuilder(liveId: Int, viewCount: Int, user: UserAuth) -> RequestBuilder<MessageResponseDTO> {
        let request = LiveClientAPI.joinLiveWithRequestBuilder(liveId: liveId, viewCount: viewCount)
        return enrich(requestBuilder: request, auth: user.auth)
    }

    class func pollLiveStatusWithRequestBuilder(liveId: Int, user: UserAuth) -> RequestBuilder<PollInfoDTO> {
        let request = LiveClientAPI.pollLiveStatusWithRequestBuilder(liveId: liveId)
        return enrich(requestBuilder: request, auth: user.auth)
    }
}
