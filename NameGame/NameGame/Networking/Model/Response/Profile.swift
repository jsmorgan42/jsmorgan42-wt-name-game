//
//  Person.swift
//  NameGame
//
//  Created by Jesse Morgan on 1/15/21.
//  Copyright © 2021 Jesse Morgan. All rights reserved.
//

import Foundation

struct Profile: Codable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.firstName)
    }

    static func == (lhs: Profile, rhs: Profile) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    var uuid = UUID()
    
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
    
    private enum CodingKeys: String, CodingKey {
        case id, type, slug, jobTitle, firstName, lastName, headshot, bio, socialLinks
    }
}


