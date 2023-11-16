//
//  ListsViewController.swift
//  UICollectionView
//
//  Created by 김건우 on 11/14/23.
//

import UIKit

class ListsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var config = UICollectionLayoutListConfiguration(appearance: .grouped)
        config.headerMode = .supplementary
        config.separatorConfiguration.color = UIColor.systemRed
        // ⭐️ 각 셀마다 저마다 다른 구분선 스타일을 적용함.
        config.itemSeparatorHandler = { indexPath, config in
            let row = indexPath.item
            let section = indexPath.section
            
            var lastRow = 0
            if let sectionID = AppSectionData.dataSource.sectionIdentifier(for: section) {
                lastRow = AppSectionData.dataSource.snapshot().numberOfItems(inSection: sectionID)
                lastRow = lastRow > 0 ? lastRow - 1 : 0 // 셀은 인덱스 0부터 시작하므로 -1을 빼줌.
            }
            var configuration = config
            // 각 섹션의 첫 번째 셀의 상단 구분선 지우기
            configuration.topSeparatorVisibility = row == 0 ? .hidden : .automatic
            // 각 섹션의 마지막 셀의 하단 구분선 지우기
            configuration.bottomSeparatorVisibility = row == lastRow ? .hidden : .automatic
            return configuration
        }
        // ⭐️ 후행 스와이프 액션 버튼을 구현함.
        config.trailingSwipeActionsConfigurationProvider = { indexPath in
            let button = UIContextualAction(style: .normal, title: "Remove") { action, view, completion in
                if let itemID = AppSectionData.dataSource.itemIdentifier(for: indexPath),
                   let sectionID  = AppSectionData.dataSource.sectionIdentifier(for: indexPath.section) {
                    AppSectionData.items.removeAll(where: { $0.id == itemID })
                    
                    var currentSnapshot = AppSectionData.dataSource.snapshot()
                    currentSnapshot.deleteItems([itemID])
                    if currentSnapshot.numberOfItems(inSection: sectionID) <= 0 {
                        AppSectionData.sections.removeAll(where: { $0.id == sectionID })
                        currentSnapshot.deleteSections([sectionID])
                    }
                    AppSectionData.dataSource.apply(currentSnapshot)
                }
                completion(true)
            }
            let config = UISwipeActionsConfiguration(actions: [button])
            return config
        }
        
        var layout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        
        prepareDatasource()
        prepareSnapshot()
    }
    
    func prepareDatasource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, FoodsData.ID> { cell, indexPath, itemID in
            if let item = AppSectionData.items.first(where: { $0.id == itemID }) {
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
        
        AppSectionData.dataSource = UICollectionViewDiffableDataSource<AlphabetSections.ID, FoodsData.ID>(collectionView: collectionView) { collectionView, indexPath, itemID in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemID)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<ListHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, kind, indexPath in
            supplementaryView.textView.text = AppSectionData.sections[indexPath.section].name
        }
        
        AppSectionData.dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    func prepareSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<AlphabetSections.ID, FoodsData.ID>()
        snapshot.appendSections(AppSectionData.sections.map { $0.id })
        for section in AppSectionData.sections {
            let itemIDs = AppSectionData.items.compactMap { value in
                return value.section == section.name ? value.id : nil
            }
            snapshot.appendItems(itemIDs, toSection: section.id)
        }
        AppSectionData.dataSource.apply(snapshot)
    }

}

extension ListsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let itemID = AppSectionData.dataSource.itemIdentifier(for: indexPath) {
            if let item = AppSectionData.items.first(where: { $0.id == itemID }) {
                item.selected.toggle()
                
                var current = AppSectionData.dataSource.snapshot()
                current.reconfigureItems([itemID])
                AppSectionData.dataSource.apply(current)
                
                collectionView.deselectItem(at: indexPath, animated: true)
            }
        }
    }
    
}
