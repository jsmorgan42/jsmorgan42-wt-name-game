//
//  API.swift
//  NameGame
//
//  Created by Jesse Morgan on 1/17/21.
//  Copyright © 2021 Jesse Morgan. All rights reserved.
//

import Foundation

class API {
    
    static let dataURL = "https://willowtreeapps.com/api/v1.0/profiles/"
    
    static func getProfiles(_ completion: @escaping ([Profile]?, Error?) -> Void) {
        let url = URL(string: dataURL)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let profiles = try decoder.decode([Profile].self, from: data)
                DispatchQueue.main.async {
                    completion(profiles, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    NSLog("JSON Parsing error: \(error)")
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }

}
