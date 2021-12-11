//
//  DigestedRequestBuilder.swift.swift
//  AutoVlive
//
//  Created by DeniZ Dobanda on 11.12.21.
//

import AutoVliveClientApi
import CoreServices
import Foundation

class DigestedRequestBuilderFactory: RequestBuilderFactory {
    func getNonDecodableBuilder<T>() -> RequestBuilder<T>.Type {
        DigestedRequestBuilder<T>.self
    }

    func getBuilder<T: Decodable>() -> RequestBuilder<T>.Type {
        DigestedDecorableRequestBuilder<T>.self
    }
}

open class DigestedDecorableRequestBuilder<T: Decodable>: AlamofireDecodableRequestBuilder<T> {
    public required init(method: String, URLString: String, parameters: [String: Any]?, headers: [String: String] = [:]) {
        let url = URLString.vliveDigested
        super.init(method: method, URLString: url, parameters: parameters, headers: headers)
    }
}

open class DigestedRequestBuilder<T>: AlamofireRequestBuilder<T> {
    public required init(method: String, URLString: String, parameters: [String: Any]?, headers: [String: String] = [:]) {
        let url = URLString.vliveDigested
        super.init(method: method, URLString: url, parameters: parameters, headers: headers)
    }
}
