//
//  PrimaryButton.swift
//  NameGame
//
//  Created by Jesse Morgan on 1/15/21.
//  Copyright © 2021 Jesse Morgan. All rights reserved.
//

import UIKit

class PrimaryButton: UIButton {
    
    var height: CGFloat = 56.0
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: frame.width, height: height)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setStyle()
    }
    
    private func setStyle() {
        layer.cornerRadius = 14
        
        setTitleColor(.primaryFontColor, for: .normal)
        let fontSize = [traitCollection.horizontalSizeClass,
                        traitCollection.verticalSizeClass].contains(.regular) ? CGFloat(17) : CGFloat(24)
        titleLabel?.font = .systemFont(ofSize: fontSize)
        backgroundColor = .primaryBackgroundColor
    }
}
