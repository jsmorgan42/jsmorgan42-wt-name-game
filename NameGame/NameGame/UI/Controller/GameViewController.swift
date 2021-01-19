//
//  ViewController.swift
//  NameGame
//
//  Created by Jesse Morgan on 1/15/21.
//  Copyright © 2021 Jesse Morgan. All rights reserved.
//

import Foundation
import UIKit

final class GameViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Profile>! = nil
    
    var isPractice = false
    
    var profiles: [Profile] = []
    
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
                guard let headshot = profile.headshot, let imageUrlText = headshot.imageUrl, let imageUrl = URL(string: "https:\(imageUrlText)") else {
                    return cell
                }
                let data = try? Data(contentsOf: imageUrl)

                if let imageData = data {
                    let image = UIImage(data: imageData)
                    cell.imageView.image = image
                }
                
                self.nameLabel.text = "\(profile.firstName) \(profile.lastName)"
                
            return cell
        })
        updateSnapshot()
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Profile>()
        snapshot.appendSections([Section.main])
        var randomProfiles: [Profile] = []
        for _ in 0..<6 {
            guard let randomProfile = profiles.randomElement() else { break }
            randomProfiles.append(randomProfile)
        }
        snapshot.appendItems(randomProfiles, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureCollectionView() {
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
        let fractionalHeight = traitCollection.sizeClass == .hCompact_vRegular ? 0.5 : 0.3
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(CGFloat(fractionalHeight)),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(175))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
//        let layout = UICollectionViewCompositionalLayout {
//            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
//
//            let itemFractionalWidth = CGFloat(1.0 / 2.0)
//
//            let item = self.layoutItem(fractionalWidth: itemFractionalWidth, fractionalHeight: 1.0)
//
//            let columnGroup = self.horizontalLayoutGroup(fractionalWidth: 1.0, fractionalHeight: 1.0, items: [item, item, item])
//            let rowGroup = self.verticalLayoutGroup(fractionalWidth: 1.0, fractionalHeight: 1.0 / 3.0, items: [columnGroup, columnGroup, columnGroup])
//            let section = NSCollectionLayoutSection(group: rowGroup)
//
//            return section
//
//        }
//        return layout
    }
    
    private func layoutItem(fractionalWidth: CGFloat, fractionalHeight: CGFloat) -> NSCollectionLayoutItem {
        return NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(fractionalWidth),
            heightDimension: .fractionalHeight(fractionalHeight)))
    }
    
    private func horizontalLayoutGroup(fractionalWidth: CGFloat, fractionalHeight: CGFloat, items: [NSCollectionLayoutItem]) -> NSCollectionLayoutGroup {
        return NSCollectionLayoutGroup.horizontal(
        layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(fractionalHeight),
            heightDimension: .fractionalHeight(fractionalWidth)),
        subitems: items )
    }
    
    private func verticalLayoutGroup(fractionalWidth: CGFloat, fractionalHeight: CGFloat, items: [NSCollectionLayoutItem]) -> NSCollectionLayoutGroup {
        return NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(fractionalHeight),
            heightDimension: .fractionalHeight(fractionalWidth)),
        subitems: items )
    }
    
}

