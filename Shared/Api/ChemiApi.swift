//
//  ChemiApi.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 11.12.21.
//

import AutoVliveApi
import Foundation

class ChemiApi: ApiAuthorized {
    // MARK: Internal

    class func getChemiInfo(
        channelId: Int = 468,
        user: UserAuth
    ) async throws -> ChemiStatusDTO {
        let some: ChemiInfoDTO = try await withCheckedThrowingContinuation { cont in
            getChemiLevelWithRequestBuilder(channelId: channelId, user: user).execute(AutoVliveApiAPI.apiResponseQueue) {
                Api.throwingParse($0, cont)
            }
        }
        return some.result
    }

    // MARK: Private

    private class func getChemiLevelWithRequestBuilder(channelId: Int, user: UserAuth) -> RequestBuilder<ChemiInfoDTO> {
        let builder = ChemiClientAPI.getChemiLevelWithRequestBuilder(channelId: channelId)
        return enrich(requestBuilder: builder, auth: user.auth)
    }
}
