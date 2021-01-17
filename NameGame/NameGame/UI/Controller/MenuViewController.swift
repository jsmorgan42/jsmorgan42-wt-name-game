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
    
    @IBOutlet var topAnchorLogoConstraint: NSLayoutConstraint!
    @IBOutlet var leftAnchorLogoConstraint: NSLayoutConstraint!
    @IBOutlet var rightAnchorLogoConstraint: NSLayoutConstraint!
    @IBOutlet var bottomAnchorLogoConstraint: NSLayoutConstraint!
    @IBOutlet var centerXStackViewConstraint: NSLayoutConstraint!
    @IBOutlet var centerYStackViewConstraint: NSLayoutConstraint!
    @IBOutlet var trailingAnchorStackViewConstraint: NSLayoutConstraint!
    @IBOutlet var bottomAnchorStackViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .menuBackgroundColor
        navigationController?.isNavigationBarHidden = true
        stackView.setCustomSpacing(56, after: titleLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.layoutIfNeeded()
        updateLargeDeviceConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLargeDeviceConstraints()
    }
    
    private func updateLargeDeviceConstraints() {
        if traitCollection.sizeClass == .hRegular_vRegular {
            let isLandscape = view.bounds.size.width > view.bounds.size.height
            
            let landscapeConstraints = [
                bottomAnchorLogoConstraint!,
                trailingAnchorStackViewConstraint!,
                centerYStackViewConstraint!
            ]
            
            let portraitConstraints = [
                rightAnchorLogoConstraint!,
                centerXStackViewConstraint!,
                bottomAnchorStackViewConstraint!
            ]
            
            if isLandscape {
                NSLayoutConstraint.deactivate(portraitConstraints)
                NSLayoutConstraint.activate(landscapeConstraints)
                leftAnchorLogoConstraint.constant = -156
                topAnchorLogoConstraint.constant = -182
            } else {

                NSLayoutConstraint.deactivate(landscapeConstraints)
                NSLayoutConstraint.activate(portraitConstraints)
                leftAnchorLogoConstraint.constant = -42
                topAnchorLogoConstraint.constant = -48
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if segue.identifier == "PracticeModeSegue", let gameViewController = segue.destination as? GameViewController {
        } else if segue.identifier == "TimedModeSegue", let gameViewController = segue.destination as? GameViewController {
        }
    }
}

