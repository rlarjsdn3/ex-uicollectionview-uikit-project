//
//  SectionsViewController.swift
//  UICollectionView
//
//  Created by 김건우 on 11/13/23.
//

import UIKit

class SectionsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var appSectionData: ApplicationSectionData = ApplicationSectionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customLayout = createLayout()
        collectionView.collectionViewLayout = customLayout
        
        prepareDatasource()
        prepareSnapshot()
    }
    
    func prepareDatasource() {
        // ⭐️ 셀을 등록하고, 켈력션 뷰에 올리기
        let cellRegistration = UICollectionView.CellRegistration<FoodCell, FoodsData.ID> { [unowned self] cell, indexPath, itemID in
            if let item = appSectionData.items.first(where: { $0.id == itemID }) {
                cell.picture.image = UIImage(named: item.image)
            }
        }
        
        appSectionData.dataSource = UICollectionViewDiffableDataSource<AlphabetSections.ID, FoodsData.ID>(collectionView: collectionView) { collectionView, indexPath, itemID in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemID)
        }
        
        // ⭐️ 헤더를 등록하고, 컬렉션 뷰에 올리기
        let headerRegistration = UICollectionView.SupplementaryRegistration<MyHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { [unowned self] supplementaryView, kind, indexPath in
            supplementaryView.pictureView.image = UIImage(systemName: "clock")
            supplementaryView.textView.text = appSectionData.sections[indexPath.section].name
        }
        
        appSectionData.dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    func prepareSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<AlphabetSections.ID, ItemsData.ID>()
        snapshot.appendSections(appSectionData.sections.map { $0.id })
        for section in appSectionData.sections {
            let itemIDs = appSectionData.items.compactMap { value in
                return value.section == section.name ? value.id : nil
            }
            snapshot.appendItems(itemIDs, toSection: section.id)
        }
        appSectionData.dataSource.apply(snapshot)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        
        // ⭐️ 공통적으로 스크린 사이즈에 비해 셀(그룹) 여백이 많이 남을 경우, 셀을 우겨넣는 게 기본 작동 방식임.
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalWidth(0.5)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 5, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.5)
        )
        // ⭐️ 수평 방향으로 배치한 셀들이 하나의 그룹임.
        // 여백이 모자랄 경우, 그 다음 줄에 새로운 그룹을 만들어 셀을 배치함. 하나의 그룹이 아닌 여러 개의 그룹이 만들어질 수 있음. 그룹 내 셀의 개수는 여백이 얼마냐에 따라 달라짐.
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        // ⭐️ Layout에서 헤더와 푸터의 사이즈를 정의해줘야 함.
        // (CellForItemAt 섹션에서 Supplementary View를 코드로 구현할 때, 헤더 사이즈를 정의해줘야 화면에 출력되었음)
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(60.0)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        sectionHeader.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
        
    }

}
