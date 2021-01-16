//
//  Headshot.swift
//  NameGame
//
//  Created by Jesse Morgan on 1/15/21.
//  Copyright © 2021 Jesse Morgan. All rights reserved.
//

import Foundation

struct Headshot: Codable {
    var type: String
    var mimeType: String?
    var id: String
    var imageUrl: String?
    var alternateText: String
    var height: Int?
    var width: Int?
    
    enum CodingKeys: String, CodingKey {
        case type
        case mimeType
        case id
        case imageUrl = "url"
        case alternateText = "alt"
        case height
        case width
    }
    
}
