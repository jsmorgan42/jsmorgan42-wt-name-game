//
//  RequestBuilder.swift
//  NameGame
//
//  Created by Jesse Morgan on 1/21/21.
//  Copyright © 2021 Jesse Morgan. All rights reserved.
//

import Foundation

import Foundation

enum HTTPMethod: String {
    case get
    case post
    case put
    case delete
}

struct RequestBuilder {
    private let scheme = "https"
    private let host = "willowtreeapps.com"
    
    private var path: String
    private var method: HTTPMethod
    private var params: [URLQueryItem]?
    private var body: Data?

    init(method: HTTPMethod, path: String, params: [URLQueryItem]? = nil, body: Data? = nil) {
        self.path = path
        self.method = method
        self.params = params
        self.body = body
    }
    
    var urlRequest: URLRequest {
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = "/" + path
        components.queryItems = params
        
        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()
        request.httpBody = body
        return request
    }
    
}
