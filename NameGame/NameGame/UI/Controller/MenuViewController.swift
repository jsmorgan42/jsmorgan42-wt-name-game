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
        updateLargeDeviceConstraints()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        updateLargeDeviceConstraints()
    }
    
    private func updateLargeDeviceConstraints() {
        if traitCollection.sizeClass == .hRegular_vRegular {
            let isLandscape = view.frame.size.width > view.frame.size.height
            
            let landscapeConstraints = [
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ]
            
            let portraitConstraints = [
                logoImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
                stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ]
            
            if isLandscape {
                view.removeConstraints(portraitConstraints)
                NSLayoutConstraint.activate(landscapeConstraints)
            } else {
                view.removeConstraints(landscapeConstraints)
                NSLayoutConstraint.activate(portraitConstraints)
            }
        }
    }


}

