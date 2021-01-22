//
//  ProfilesViewModel.swift
//  NameGame
//
//  Created by Jesse Morgan on 1/19/21.
//  Copyright © 2021 Jesse Morgan. All rights reserved.
//

import Foundation

enum GameProgress {
    case playing, won
}

struct ProfileViewModel {
    var allProfiles: [Profile] = []
    var currentProfiles: [Profile] = []
    var selectedProfile: Profile?
    
    var selectedLevel: Int = 1
    var score: Int = 0
    
    private let numberOfProfiles = 6
    private let maxLevel = 5
    
    mutating func resetGame() {
        selectedProfile = nil
        getNewRandomProfiles()
        selectedLevel = 1
        score = 0
    }
    
    mutating func increaseScore() {
        if score < maxLevel { score += 1 }
    }
    
    mutating func nextLevel() -> GameProgress {
        increaseScore()
        getNewRandomProfiles()
        
        if selectedLevel < maxLevel {
            selectedLevel += 1
            return .playing
        } else {
            return .won
        }
    }
    
    mutating func getNewRandomProfiles() {
        currentProfiles = []
        for _ in 0..<numberOfProfiles {
            guard let randomProfile = allProfiles.randomElement() else { break }
            currentProfiles.append(randomProfile)
        }
        selectedProfile = currentProfiles.randomElement()
    }
}
