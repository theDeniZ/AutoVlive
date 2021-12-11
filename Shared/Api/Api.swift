//
//  Api.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 23.12.21.
//

import AutoVliveApi
import Foundation

class Api {
    class func throwingParse<T>(_ result: Result<Response<T>, ErrorResponse>, _ cont: CheckedContinuation<T, Error>) {
        switch result {
        case let .success(response):
            cont.resume(returning: response.body)
        case let .failure(error):
            cont.resume(throwing: error)
        }
    }
}
