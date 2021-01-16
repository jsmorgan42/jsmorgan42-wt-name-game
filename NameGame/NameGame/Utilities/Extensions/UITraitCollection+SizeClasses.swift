//
//  UITraitCollection+SizeClasses.swift
//  NameGame
//
//  Created by Jesse Morgan on 1/15/21.
//  Copyright © 2021 Jesse Morgan. All rights reserved.
//

import Foundation
import UIKit

enum SizeClass {
    case hRegular_vRegular, hRegular_vCompact, hCompact_vRegular, hCompact_vCompact
}

extension UITraitCollection {
    var sizeClass: SizeClass {
        if horizontalSizeClass == .regular && verticalSizeClass == .regular { return .hRegular_vRegular }
        else if horizontalSizeClass == .regular && verticalSizeClass == .compact { return .hRegular_vCompact }
        else if horizontalSizeClass == .compact && verticalSizeClass == .regular { return .hCompact_vRegular }
        else { return .hCompact_vCompact }
    }
}
