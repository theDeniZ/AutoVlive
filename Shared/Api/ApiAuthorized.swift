//
//  ApiAuthorizedInterceptor.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 11.12.21.
//

import AutoVliveApi
import Foundation

protocol ApiAuthorized {
//    func enrich<T>(requestBuilder: RequestBuilder<T>, withAuthProvider authProvider: ApiAuthProvider, user: String) -> RequestBuilder<T>
}

extension ApiAuthorized {
    static func enrich<T>(requestBuilder: RequestBuilder<T>, auth: String) -> RequestBuilder<T> {
        requestBuilder.addHeader(name: "Cookie", value: "NEO_SES=\(auth)").addCredential()
    }
}
