//
//  Request.swift
//  NameGame
//
//  Created by Jesse Morgan on 1/21/21.
//  Copyright © 2021 Jesse Morgan. All rights reserved.
//

import Foundation

struct Request {
    let builder: RequestBuilder
    let completion: (Result<Data, Error>) -> Void

    init(builder: RequestBuilder, completion: @escaping (Result<Data, Error>) -> Void) {
        self.builder = builder
        self.completion = completion
    }
}

extension Request {
    
    static func get(path: String, params: [URLQueryItem]? = nil, completion: @escaping (Result<Data, Error>) -> Void) -> Request {
        let builder = RequestBuilder(method: .get, path: path, params: params, body: nil)
        return Request(builder: builder, completion: completion)
    }
    
}
