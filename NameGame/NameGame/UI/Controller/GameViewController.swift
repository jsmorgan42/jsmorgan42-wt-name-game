//
//  ViewController.swift
//  NameGame
//
//  Created by Jesse Morgan on 1/15/21.
//  Copyright © 2021 Jesse Morgan. All rights reserved.
//

import Foundation
import UIKit

enum GameMode {
    case practice, timed
}

final class GameViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    private let timerPath = UIBezierPath()
    private let timerLayer = CAShapeLayer()
    private let timerBackgroundLayer = CAShapeLayer()
    private let timerLimit: CFTimeInterval = 30
    
    let timerView = UIView(frame: CGRect.init(x: 0, y: 0, width: 20, height: 20))
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
    
    var gameMode: GameMode = .practice
    
    var profileViewModel: ProfileViewModel?
    
    private var navigationTitle: String {
        return gameMode == .practice ? NSLocalizedString("Practice Mode", comment: "Navigation bar title")
            : NSLocalizedString("Timed Mode", comment: "Navigation bar title")
    }
    
    enum Section: CaseIterable {
        case main
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.title = navigationTitle
        profileViewModel?.resetGame()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = ""
        configureCollectionView()
        if gameMode == .timed {
            setupTimer()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureDataSource()
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .primaryFontColor
        collectionView.register(UINib(nibName: HeadShotCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier:  HeadShotCollectionViewCell.identifier)
    }
    
    // MARK: UICollectionViewDiffableDataSource
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(
            collectionView: collectionView,
            cellProvider: { (collectionView: UICollectionView, indexPath: IndexPath, index: Int)
                -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeadShotCollectionViewCell.identifier, for: indexPath)
                as? HeadShotCollectionViewCell else { fatalError("Failed to create new head shot collection view cell") }
                guard let profileViewModel = self.profileViewModel else { return cell }
                let profile = profileViewModel.currentProfiles[index]
                guard let headshot = profile.headshot,
                      let imageUrlText = headshot.imageUrl,
                      let imageUrl = URL(string: "https:\(imageUrlText)"),
                      let selectedProfile = profileViewModel.selectedProfile else {
                    return cell
                }
                let data = try? Data(contentsOf: imageUrl)

                if let imageData = data {
                    let image = UIImage(data: imageData)
                    cell.headShotImageView.image = image
                }
                
                self.nameLabel.text = "\(selectedProfile.firstName) \(selectedProfile.lastName)"
                cell.feedbackImageView.image = nil
            return cell
        })
        DispatchQueue.main.async {
            self.updateSnapshot()
        }
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(Array(0..<6), toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: Collection View Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if dataSource != nil { collectionView.collectionViewLayout = createLayout() }
        if traitCollection.sizeClass.isCompactHeight {
            nameLabel.textAlignment = .left
        } else {
            nameLabel.textAlignment = .center
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let fractionalHeight = CGFloat(traitCollection.sizeClass == .hCompact_vRegular ? 0.5 : 0.3)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(CGFloat(fractionalHeight)),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupFractionalHeight = CGFloat(traitCollection.sizeClass.isCompactHeight ? 0.5 : 0.35)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(groupFractionalHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let identifier = dataSource.itemIdentifier(for: indexPath),
           let cell = collectionView.cellForItem(at: indexPath) as? HeadShotCollectionViewCell,
           let profileViewModel = profileViewModel {
            if profileViewModel.currentProfiles[identifier] == profileViewModel.selectedProfile {
                cell.feedbackImageView.image = UIImage(named: "CorrectSelection")
                let gameProgress = self.profileViewModel?.nextLevel()
                if gameProgress == .won {
                    displayWin()
                } else {
                    self.collectionView.isUserInteractionEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.updateSnapshot()
                        self.collectionView.isUserInteractionEnabled = true
                    }
                }

            } else {
                cell.feedbackImageView.image = UIImage(named: "WrongSelection")
                if gameMode == .practice {
                    displayGameOver()
                }
            }
        }
    }
    
    // MARK: UIAlert
    
    private func displayGameOver() {
        let alert = UIAlertController(title: "Game Over",
                                      message: "Scored \(profileViewModel?.score ?? 0)/5", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
    }
    
    private func displayWin() {
        let alert = UIAlertController(title: "Congrats, You Won!",
                                      message: "Scored \(profileViewModel?.score ?? 0)/5", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true)
        
    }
    
    // MARK: Timer
    
    private func setupTimer() {
        setUpPath()
        setUpLayer()
        setUpBackgroundLayer()
        timerView.layer.addSublayer(timerBackgroundLayer)
        timerView.layer.addSublayer(timerLayer)
        let rightBarButton = UIBarButtonItem(customView: timerView)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func setUpPath() {
        let radius = min(timerView.bounds.width, timerView.bounds.height) / 1.2
        let center = CGPoint(x: timerView.bounds.width / 2, y: timerView.bounds.height / 2)
        let startAngle: CGFloat = -(.pi / 2)
        let endAngle: CGFloat = 3 * .pi / 2
        timerPath.addArc(withCenter: center, radius: radius / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
    }
    
    func setUpLayer() {
        timerLayer.path = timerPath.cgPath
        timerLayer.strokeColor = UIColor.primaryBackgroundColor.cgColor
        timerLayer.fillColor = UIColor.clear.cgColor
        timerLayer.lineWidth = 2
        timerLayer.strokeStart = 0
        timerLayer.strokeEnd = 1
        
        // Configure timer animation
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.displayGameOver()
        }
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = timerLimit
        timerLayer.add(animation, forKey: "strokeEndAnim")
        CATransaction.commit()
    }
    
    func setUpBackgroundLayer() {
        timerBackgroundLayer.path = timerPath.cgPath
        timerBackgroundLayer.strokeColor = UIColor.timerBackgroundColor.cgColor
        timerBackgroundLayer.fillColor = UIColor.clear.cgColor
        timerBackgroundLayer.lineWidth = 2
        timerBackgroundLayer.frame = timerView.bounds
        timerBackgroundLayer.lineCap = CAShapeLayerLineCap.round
    }
}

