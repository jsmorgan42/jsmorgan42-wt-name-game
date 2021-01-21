//
//  UIColor+AppExtensions.swift
//  NameGame
//
//  Created by Jesse Morgan on 1/15/21.
//  Copyright © 2021 Jesse Morgan. All rights reserved.
//

import Foundation

import UIKit

extension UIColor {

    // Workaround for https://openradar.appspot.com/47113341. Prevent crashing the IBDesignables agent when using a color from the asset catalog.
    private convenience init?(safelyNamed name: String) {
        self.init(named: name,
                  in: Bundle(for: AppDelegate.self),
                  compatibleWith: nil)
    }

    static let menuBackgroundColor = UIColor(safelyNamed: "MenuBackgroundColor")!
    
    static let primaryBackgroundColor = UIColor(safelyNamed: "PrimaryBackgroundColor")!
    static let primaryFontColor = UIColor(safelyNamed: "PrimaryFontColor")!
    
    static let timerBackgroundColor = UIColor(safelyNamed: "TimerBackgroundColor")!
}

