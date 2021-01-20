//
//  ProfilesViewModel.swift
//  NameGame
//
//  Created by Jesse Morgan on 1/19/21.
//  Copyright © 2021 Jesse Morgan. All rights reserved.
//

import Foundation

struct ProfileViewModel {
    var allProfiles: [Profile] = []
    var currentProfiles: [Profile] = []
    var selectedProfile: Profile?
    
    var selectedLevel: Int = 1
    var score: Int = 0
    
    mutating func resetGame() {
        selectedProfile = nil
        getNewRandomProfiles()
        selectedLevel = 1
        score = 0
    }
    
    mutating func increaseScore() {
        if score < 5 { score += 1 }
    }
    
    mutating func nextLevel() {
        if selectedLevel < 5 { selectedLevel += 1 }
        getNewRandomProfiles()
    }
    
    mutating func getNewRandomProfiles() {
        currentProfiles = []
        for _ in 0..<6 {
            guard let randomProfile = allProfiles.randomElement() else { break }
            currentProfiles.append(randomProfile)
        }
        selectedProfile = currentProfiles.randomElement()
    }
}
