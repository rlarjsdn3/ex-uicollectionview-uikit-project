//
//  ListsViewController.swift
//  UICollectionView
//
//  Created by 김건우 on 11/14/23.
//

import UIKit

class ListsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var appData = ApplicationSectionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var config = UICollectionLayoutListConfiguration(appearance: .grouped)
        config.headerMode = .supplementary
        config.separatorConfiguration.color = UIColor.systemRed
        // ⭐️ 각 셀마다 저마다 다른 구분선 스타일을 적용함.
        config.itemSeparatorHandler = { [unowned  self] indexPath, config in
            let row = indexPath.item
            let section = indexPath.section
            
            var lastRow = 0
            if let sectionID = appData.dataSource.sectionIdentifier(for: section) {
                lastRow = appData.dataSource.snapshot().numberOfItems(inSection: sectionID)
                lastRow = lastRow > 0 ? lastRow - 1 : 0 // 셀은 인덱스 0부터 시작하므로 -1을 빼줌.
            }
            var configuration = config
            // 각 섹션의 첫 번째 셀의 상단 구분선 지우기
            configuration.topSeparatorVisibility = row == 0 ? .hidden : .automatic
            // 각 섹션의 마지막 셀의 하단 구분선 지우기
            configuration.bottomSeparatorVisibility = row == lastRow ? .hidden : .automatic
            return configuration
        }
        
        var layout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        
        prepareDatasource()
        prepareSnapshot()
    }
    
    func prepareDatasource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, FoodsData.ID> { [unowned self] cell, indexPath, itemID in
            if let item = appData.items.first(where: { $0.id == itemID }) {
                var contentConfig = cell.defaultContentConfiguration()
                contentConfig.text = item.name
                contentConfig.secondaryText = "Calories: \(item.calories)"
                contentConfig.image = UIImage(named: item.image)
                contentConfig.imageProperties.maximumSize = CGSize(width: 60, height: 60)
                cell.contentConfiguration = contentConfig
                
                let selected = item.selected
                cell.accessories = selected ? [.checkmark()] : []
            }
        }
        
        appData.dataSource = UICollectionViewDiffableDataSource<AlphabetSections.ID, FoodsData.ID>(collectionView: collectionView) { collectionView, indexPath, itemID in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemID)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<ListHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { [unowned self] supplementaryView, kind, indexPath in
            supplementaryView.textView.text = appData.sections[indexPath.section].name
        }
        
        appData.dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    func prepareSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<AlphabetSections.ID, FoodsData.ID>()
        snapshot.appendSections(appData.sections.map { $0.id })
        for section in appData.sections {
            let itemIDs = appData.items.compactMap { value in
                return value.section == section.name ? value.id : nil
            }
            snapshot.appendItems(itemIDs, toSection: section.id)
        }
        appData.dataSource.apply(snapshot)
    }

}

extension ListsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let itemID = appData.dataSource.itemIdentifier(for: indexPath) {
            if let item = appData.items.first(where: { $0.id == itemID }) {
                item.selected.toggle()
                
                var current = appData.dataSource.snapshot()
                current.reconfigureItems([itemID])
                appData.dataSource.apply(current)
                
                collectionView.deselectItem(at: indexPath, animated: true)
            }
        }
    }
    
}
