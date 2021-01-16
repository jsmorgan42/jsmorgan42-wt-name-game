//
//  Person.swift
//  NameGame
//
//  Created by Jesse Morgan on 1/15/21.
//  Copyright © 2021 Jesse Morgan. All rights reserved.
//

import Foundation

struct Profile: Codable {
    var id: String
    var type: String
    var slug: String
    var jobTitle: String?
    var firstName: String
    var lastName: String
    var headshot: Headshot?
    var bio: String?
    var socialLinks: [SocialLink]
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

func == (lhs: Profile, rhs: Profile) -> Bool {
    return lhs.id == rhs.id
}
