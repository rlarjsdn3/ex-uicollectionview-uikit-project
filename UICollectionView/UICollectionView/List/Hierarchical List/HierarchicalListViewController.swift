//
//  HierarchicalListViewController.swift
//  UICollectionView
//
//  Created by 김건우 on 11/16/23.
//

import UIKit

class HierarchicalListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var hierarchicalData = HierarchicalData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView.collectionViewLayout = layout
        
        prepareDatasource()
        prepareSnapshot()
    }
    
    func prepareDatasource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MainItems.ID> { [unowned self] cell, indexPath, itemID in
            if let item = self.getItem(id: itemID) {
                var contentConfig = cell.defaultContentConfiguration()
                contentConfig.text = item.name
                cell.contentConfiguration = contentConfig
                cell.accessories = item.options != nil ? [.outlineDisclosure()] : []
            }
        }
        
        hierarchicalData.dataSource = UICollectionViewDiffableDataSource<MainSections, MainItems.ID>(collectionView: collectionView) { collectionView, indexPath, itemID in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemID)
        }
    }
    
    func prepareSnapshot() {
        var snapshot = NSDiffableDataSourceSectionSnapshot<MainItems.ID>()
        for mainItem in hierarchicalData.items {
            snapshot.append([mainItem.id], to: nil)
            snapshot.append(mainItem.options.map { $0.id }, to: mainItem.id)
        }
        hierarchicalData.dataSource.apply(snapshot, to: .main, animatingDifferences: false)
    }
    
    func getItem(id: MainItems.ID) -> MainItems? {
        var item = hierarchicalData.items.first(where: { $0.id == id })
        if item == nil {
            for main in hierarchicalData.items {
                if let found = main.options.first(where: { $0.id == id }) {
                    item = found
                }
            }
        }
        return item
    }

}
