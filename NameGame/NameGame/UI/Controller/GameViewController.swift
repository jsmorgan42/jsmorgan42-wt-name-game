//
//  ViewController.swift
//  NameGame
//
//  Created by Jesse Morgan on 1/15/21.
//  Copyright © 2021 Jesse Morgan. All rights reserved.
//

import Foundation
import UIKit

final class GameViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Profile>! = nil
    
    var isPractice = false
    
    var profileViewModel: ProfileViewModel?
    
    private var navigationTitle: String {
        return isPractice ? NSLocalizedString("Practice Mode", comment: "Navigation bar title")
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
        configureCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureDataSource()
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Profile>(
            collectionView: collectionView,
            cellProvider: { (collectionView: UICollectionView, indexPath: IndexPath, profile: Profile)
                -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeadShotCollectionViewCell.identifier, for: indexPath)
                as? HeadShotCollectionViewCell else { fatalError("Failed to create new head shot collection view cell") }
                guard let headshot = profile.headshot,
                      let imageUrlText = headshot.imageUrl,
                      let imageUrl = URL(string: "https:\(imageUrlText)"),
                      let profileViewModel = self.profileViewModel,
                      let selectedProfile = profileViewModel.selectedProfile else {
                    return cell
                }
                let data = try? Data(contentsOf: imageUrl)

                if let imageData = data {
                    let image = UIImage(data: imageData)
                    cell.headShotImageView.image = image
                }
                
                self.nameLabel.text = "\(selectedProfile.firstName) \(selectedProfile.lastName)"
                
            return cell
        })
        updateSnapshot()
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Profile>()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(profileViewModel?.currentProfiles ?? [], toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .primaryFontColor
        collectionView.register(UINib(nibName: HeadShotCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier:  HeadShotCollectionViewCell.identifier)
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let profile = dataSource.itemIdentifier(for: indexPath),
           let cell = collectionView.cellForItem(at: indexPath) as? HeadShotCollectionViewCell,
           let profileViewModel = profileViewModel {
            if profile == profileViewModel.selectedProfile {
//                cell.feedbackImageView.image = UIImage(named: "CorrectSelection")
                self.profileViewModel?.nextLevel()
                updateSnapshot()
            } else {
                cell.feedbackImageView.image = UIImage(named: "WrongSelection")
                displayGameOver()
            }
        }
    }
    
    private func displayGameOver() {
        let alert = UIAlertController(title: "Game Over",
                                      message: "Scored \(profileViewModel?.score ?? 0)/5", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))

        self.present(alert, animated: true)
    }
    
//    private func layoutItem(fractionalWidth: CGFloat, fractionalHeight: CGFloat) -> NSCollectionLayoutItem {
//        return NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(fractionalWidth),
//            heightDimension: .fractionalHeight(fractionalHeight)))
//    }
//
//    private func horizontalLayoutGroup(fractionalWidth: CGFloat, fractionalHeight: CGFloat, items: [NSCollectionLayoutItem]) -> NSCollectionLayoutGroup {
//        return NSCollectionLayoutGroup.horizontal(
//        layoutSize: NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(fractionalHeight),
//            heightDimension: .fractionalHeight(fractionalWidth)),
//        subitems: items )
//    }
    
}

