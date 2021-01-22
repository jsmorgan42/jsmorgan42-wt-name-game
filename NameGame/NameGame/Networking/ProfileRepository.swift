//
//  ProfileRepository.swift
//  NameGame
//
//  Created by Jesse Morgan on 1/21/21.
//  Copyright © 2021 Jesse Morgan. All rights reserved.
//

import Foundation

class ProfileRepository {
    
    static var shared = ProfileRepository()
    
    func getProfiles(completion: @escaping (Result<[Profile], Error>) -> Void) {
        let request = Request.get(path: "/api/v1.0/profiles/", completion: { (result) in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode([Profile].self, from: data)
                    print("Successfully fetched profile data")
                    completion(.success(response))
                } catch (let error) {
                    print("Failed to decode to APIResponse: \(error)")
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
        HTTPClient.shared.execute(request)
    }
}
