//
//  VliveDigest.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 11.12.21.
//

import Foundation

extension String {
    var vliveDigested: String {
        let timestamp = currentTimeMillis()
        let digest = "\(self)\(timestamp)".digest(algorithm: .sha1).base64URLEncoded()
        let appender = contains("?") ? "&" : "?"

        return "\(self)\(appender)msgpad=\(timestamp)&md=\(digest)"
    }

    private func currentTimeMillis() -> Int64 {
        let nowDouble = Date().timeIntervalSince1970
        return Int64(nowDouble * 1000)
    }

    private func base64URLEncoded() -> String {
        replacingOccurrences(of: "=", with: "%3D")
            .replacingOccurrences(of: "+", with: "%2B")
            .replacingOccurrences(of: "/", with: "%2F")
    }
}
