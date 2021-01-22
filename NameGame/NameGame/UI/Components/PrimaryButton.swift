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
    var width: CGFloat {
        return traitCollection.sizeClass == .hRegular_vRegular ? 433 : 359
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: height)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setStyle()
    }
    
    private func setStyle() {
        layer.cornerRadius = 14
        setTitleColor(.primaryFontColor, for: .normal)
        let fontSize = traitCollection.sizeClass == .hRegular_vRegular ? CGFloat(24) : CGFloat(17)
        titleLabel?.font = .systemFont(ofSize: fontSize)
        backgroundColor = .primaryBackgroundColor
    }
}
