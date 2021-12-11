//
//  LikeApi.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 11.12.21.
//

import AutoVliveApi
import AutoVliveClientApi
import Foundation

enum LikeApiError: Error {
    case messageError(String)
    case unknownError(String)

    // MARK: Public

    public var localizedDescription: String {
        switch self {
        case let .messageError(message):
            return "Message error: \(message)"
        case let .unknownError(error):
            return "Unknown error: \(error)"
        }
    }
}

class FastLikeApi: LikeApi {
    @discardableResult override class func postLike(count: Int, videoSeq: Int, user: UserWithAuth) async throws -> Like {
        let url = (AutoVliveClientApiAPI.basePath + "/globalV2/vam-app/old/like").vliveDigested
        let data: Data = "count=\(count)&videoSeq=\(videoSeq)".data(using: .utf8)!

        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("NEO_SES=\(user.auth)", forHTTPHeaderField: "Cookie")
        request.httpBody = data

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let message = try JSONDecoder().decode(MessageResponseDTO.self, from: data)
            if message.message == "success" {
                return Like(response: message, amount: count)
            } else {
                throw LikeApiError.messageError(message.message)
            }
        } catch {
            throw LikeApiError.unknownError(error.localizedDescription)
        }
    }
}
