//
//  HeadShotCollectionViewCell.swift
//  NameGame
//
//  Created by Jesse Morgan on 1/15/21.
//  Copyright © 2021 Jesse Morgan. All rights reserved.
//

import Foundation
import UIKit

class HeadShotCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "head-shot-cell"
    static let nibName = "HeadShotCollectionViewCell"
    
    @IBOutlet var headShotImageView: UIImageView!
    @IBOutlet var feedbackImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setPlaceholderImage()
        feedbackImageView.alpha = 0.85
    }
    
    private func setPlaceholderImage() {
        headShotImageView.image = UIImage(named: "MenuBackgroundImage")
    }
    
}
