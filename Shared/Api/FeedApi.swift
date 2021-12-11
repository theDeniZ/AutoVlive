//
//  FeedApi.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 11.12.21.
//

import AutoVliveApi
import Foundation

class FeedApi: ApiAuthorized {
    // MARK: Internal

    class func checkLogin(user: UserAuth) async throws -> LoginCheckInfoDTO {
        try await withCheckedThrowingContinuation { cont in
            checkLoginWithRequestBuilder(user: user).execute(AutoVliveApiAPI.apiResponseQueue) {
                Api.throwingParse($0, cont)
            }
        }
    }

    class func getFeedInfo(includeBanners: Int? = nil, maxNumOfRows: Int? = nil, user: UserAuth) async throws -> FeedDTO {
        try await withCheckedThrowingContinuation { cont in
            getFeedInfoWithRequestBuilder(includeBanners: includeBanners, maxNumOfRows: maxNumOfRows, user: user).execute(AutoVliveApiAPI.apiResponseQueue) {
                Api.throwingParse($0, cont)
            }
        }
    }

    @discardableResult class func initClient(user: UserAuth) async throws -> InitInfoDTO {
        try await withCheckedThrowingContinuation { cont in
            initClientWithRequestBuilder(user: user).execute(AutoVliveApiAPI.apiResponseQueue) {
                Api.throwingParse($0, cont)
            }
        }
    }

    // MARK: Private

    private class func checkLoginWithRequestBuilder(user: UserAuth) -> RequestBuilder<LoginCheckInfoDTO> {
        let builder = FeedClientAPI.checkLoginWithRequestBuilder()
        return enrich(requestBuilder: builder, auth: user.auth)
    }

    private class func getFeedInfoWithRequestBuilder(includeBanners: Int? = nil, maxNumOfRows: Int? = nil, user: UserAuth) -> RequestBuilder<FeedDTO> {
        let builder = FeedClientAPI.getFeedInfoWithRequestBuilder(includeBanners: includeBanners, maxNumOfRows: maxNumOfRows)
        return enrich(requestBuilder: builder, auth: user.auth)
    }

    private class func initClientWithRequestBuilder(user: UserAuth) -> RequestBuilder<InitInfoDTO> {
        let builder = FeedClientAPI.initClientWithRequestBuilder()
        return enrich(requestBuilder: builder, auth: user.auth)
    }
}
