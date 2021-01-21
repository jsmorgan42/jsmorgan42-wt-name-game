//
//  UIView+DeviceOrientation.swift
//  NameGame
//
//  Created by Jesse Morgan on 1/19/21.
//  Copyright © 2021 Jesse Morgan. All rights reserved.
//

import UIKit

extension UIView {
    
    enum DeviceOrientation {
        case landscape, portrait
    }
    
    var deviceOrientation: DeviceOrientation {
        if bounds.size.width > bounds.size.height { return .landscape }
        else { return .portrait }
    }
    
}
