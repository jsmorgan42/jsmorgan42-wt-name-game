//
//  ViewController.swift
//  NameGame
//
//  Created by Jesse Morgan on 1/15/21.
//  Copyright © 2021 Jesse Morgan. All rights reserved.
//

import UIKit
import Foundation

final class MenuViewController: UIViewController {
    
    @IBOutlet var loadingSpinner: UIActivityIndicatorView!
    
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
    
    private var hasServerError = false
    
    private var profileViewModel = ProfileViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = ""
        navigationController?.isNavigationBarHidden = true
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .primaryFontColor
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .menuBackgroundColor
        stackView.setCustomSpacing(56, after: titleLabel)
        updateLargeDeviceConstraints()
        fetchProfiles()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func fetchProfiles() {
        startLoading()
        ProfileRepository.shared.getProfiles { (result) in
            switch result {
            case .success(let profiles):
                self.profileViewModel.allProfiles = profiles
            case .failure(let error):
                self.hasServerError = true
                print("Failed to fetch profiles: \(error)")
            }
            DispatchQueue.main.async {
                self.stopLoading()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateLargeDeviceConstraints()
    }
    
    private func updateLargeDeviceConstraints() {
        if traitCollection.sizeClass == .hRegular_vRegular {
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
            
            if view.deviceOrientation == .landscape {
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if hasServerError {
            let alert = UIAlertController(title: "A server error occured.",
                                          message: "Please try again later.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if segue.identifier == "PracticeModeSegue", let gameViewController = segue.destination as? GameViewController {
            gameViewController.gameMode = .practice
            gameViewController.profileViewModel = profileViewModel
        } else if segue.identifier == "TimedModeSegue", let gameViewController = segue.destination as? GameViewController {
            gameViewController.gameMode = .timed
            gameViewController.profileViewModel = profileViewModel
        }
    }
    
    private func startLoading() {
        loadingSpinner.startAnimating()
        practiceModeButton.isEnabled = false
        timedModeButton.isEnabled = false
    }
    
    private func stopLoading() {
        loadingSpinner.stopAnimating()
        practiceModeButton.isEnabled = true
        timedModeButton.isEnabled = true
    }
}

