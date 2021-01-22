//
//  HTTPClient.swift
//  NameGame
//
//  Created by Jesse Morgan on 1/21/21.
//  Copyright © 2021 Jesse Morgan. All rights reserved.
//

import Foundation

final class HTTPClient {
    
    static let shared = HTTPClient()
    
    let session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func execute(_ request: Request) {
        let urlRequest = request.builder.urlRequest
        let task = session.dataTask(with: urlRequest) { data, response, error in

            let result: Result<Data, Error>
            
            if let error = error {
                result = .failure(error)
            } else {
                result = .success(data ?? Data())
            }
            
            request.completion(result)
        }
        print("Executing task: \(urlRequest)")
        task.resume()
    }

}
