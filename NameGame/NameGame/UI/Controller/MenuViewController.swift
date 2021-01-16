//
//  ViewController.swift
//  NameGame
//
//  Created by Jesse Morgan on 1/15/21.
//  Copyright © 2021 Jesse Morgan. All rights reserved.
//

import UIKit

final class MenuViewController: UIViewController {

    @IBOutlet var stackView: UIStackView!
    @IBOutlet var logoImageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var practiceModeButton: PrimaryButton!
    @IBOutlet var timedModeButton: PrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .menuBackgroundColor
        navigationController?.isNavigationBarHidden = true
        stackView.setCustomSpacing(56, after: titleLabel)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if traitCollection.sizeClass == .hRegular_vRegular {
            if size.width > size.height {
                print("landscape")
            } else {
                print("portrait")
            }
        }
    }


}

