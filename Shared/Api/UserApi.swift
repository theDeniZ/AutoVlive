//
//  UserApi.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 11.12.21.
//

import AutoVliveApi
import Foundation

class UserApi: ApiAuthorized {
    // MARK: Internal

    class func getUserInfo(
        withActivityInfo: Bool = true,
        withSns: Bool = true,
        waitSeconds waitTime: UInt32? = nil,
        user: UserAuth
    ) async throws -> UserResultDTO {
        let some: UserDTO = try await withCheckedThrowingContinuation { cont in
            if let waitTime = waitTime {
                sleep(waitTime)
            }
            getUserInfoWithRequestBuilder(withActivityInfo: withActivityInfo, withSns: withSns, user: user).execute(AutoVliveApiAPI.apiResponseQueue) {
                Api.throwingParse($0, cont)
            }
        }
        return some.result
    }

    // MARK: Private

    private class func getUserInfoWithRequestBuilder(withActivityInfo: Bool? = nil, withSns: Bool? = nil, user: UserAuth) -> RequestBuilder<UserDTO> {
        let builder = UserClientAPI.getUserInfoWithRequestBuilder(withActivityInfo: withActivityInfo, withSns: withSns)
        return enrich(requestBuilder: builder, auth: user.auth)
    }
}
