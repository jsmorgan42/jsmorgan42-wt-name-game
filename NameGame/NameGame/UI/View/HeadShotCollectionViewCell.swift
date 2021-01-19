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
    
    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setImage()
    }
    
    private func setImage() {
        imageView.image = UIImage(named: "MenuBackgroundImage")
    }
    
}
