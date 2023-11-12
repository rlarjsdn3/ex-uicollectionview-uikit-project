//
//  CompositionalLayoutViewController.swift
//  UICollectionView
//
//  Created by 김건우 on 11/12/23.
//

import UIKit

class CompositionalLayoutViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var appData: ApplicationData = ApplicationData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customLayout = createLayout()
        collectionView.collectionViewLayout = customLayout
        
        prepareDatasource()
        prepareSnapshot()
    }
    
    func prepareDatasource() {
        let cellRegistration = UICollectionView.CellRegistration<FoodCell, ItemsData.ID> { [unowned self] cell, indexPath, itemID in
            if let item = appData.items.first(where: { $0.id == itemID }) {
                cell.picture.image = UIImage(named: item.image)
            }
        }
        
        appData.dataSource = UICollectionViewDiffableDataSource<Sections, ItemsData.ID>(collectionView: collectionView) { collectionView, indexPath, itemID in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemID)
        }
    }
    
    func prepareSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, ItemsData.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(appData.items.map { $0.id })
        appData.dataSource.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.2),
            heightDimension: .fractionalWidth(0.2)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 5, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.2)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

}
