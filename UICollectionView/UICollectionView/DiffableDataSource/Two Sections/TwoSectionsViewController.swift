//
//  TwoSectionsViewController.swift
//  UICollectionView
//
//  Created by 김건우 on 11/13/23.
//

import UIKit

class TwoSectionsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customLayout = createLayout()
        collectionView.collectionViewLayout = customLayout
        collectionView.delegate = self
        
        prepareDatasource()
        prepareSnapshot()
    }
    
    func prepareDatasource() {
        let cellRegistration = UICollectionView.CellRegistration<FoodCell, ItemsData.ID> { cell, indexPath, itemID in
            if let item = AppData.items.first(where: { $0.id == itemID}) {
                cell.picture.image = UIImage(named: item.image)
            }
        }
        
        AppData.dataSelectedSource = UICollectionViewDiffableDataSource<SelectedSections, ItemsData.ID>(collectionView: collectionView) { collectionView, indexPath, itemID in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemID)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<MyHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { headerView, kind, indexPath in
            // ⭐️ 섹션 ID를 하나씩 가져와서
            if let sectionID = AppData.dataSelectedSource.sectionIdentifier(for: indexPath.section) {
                headerView.pictureView.image = UIImage(systemName: "clock")
                // ⭐️ 각 센션에 맞게 텍스트를 삽입하기
                headerView.textView.text = (sectionID == .selected ? "선택된 음식" : "선택 가능한 음식")
            }
        }
        
        AppData.dataSelectedSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
    }
    
    func prepareSnapshot() {
        // ⭐️ 섹션만 데이터 소스에 반영해놓고,
        var snapshot = NSDiffableDataSourceSnapshot<SelectedSections, ItemsData.ID>()
        snapshot.appendSections([.selected, .available])
        AppData.dataSelectedSource.apply(snapshot, animatingDifferences: true, completion: nil)
        
        // ⭐️ 섹션에 아이템을 추가한 결과를 데이터 소스에 반영함.
        let selectedIDs = AppData.items.compactMap { value in
            return value.selected ? value.id : nil
        }
        // SectionSnapshot으로 해당 섹션에 속하는 아이템만 관리하도록 함.
        var selectedSnapshot = NSDiffableDataSourceSectionSnapshot<ItemsData.ID>()
        selectedSnapshot.append(selectedIDs)
        AppData.dataSelectedSource.apply(selectedSnapshot, to: .selected, animatingDifferences: false, completion: nil)
        
        // ⭐️ 섹션에 아이템을 추가한 결과를 데이터 소스에 빈영함.
        let availableIDs = AppData.items.compactMap { value in
            return value.selected ? nil : value.id
        }
        // SectionSnapshot으로 해당 섹션에 속하는 아이템만 관리하도록 함.
        var availableSnapshot = NSDiffableDataSourceSectionSnapshot<ItemsData.ID>()
        availableSnapshot.append(availableIDs)
        AppData.dataSelectedSource.apply(availableSnapshot, to: .available, animatingDifferences: false, completion: nil)
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

extension TwoSectionsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let itemID = AppData.dataSelectedSource.itemIdentifier(for: indexPath) {
            if let item = AppData.items.first(where: { $0.id == itemID }) {
                // 아이템이 선택된 상태라면
                if item.selected {
                    var selectedSnapshot = AppData.dataSelectedSource.snapshot(for: .selected)
                    // 선택된 섹션에서 아이템 삭제
                    selectedSnapshot.delete([itemID])
                    AppData.dataSelectedSource.apply(selectedSnapshot, to: .selected, animatingDifferences: true, completion: nil)
                    
                    item.selected = false
                    
                    // 선택 가능한 섹션에서 선택 가능한 아이템을 골래내어 추가
                    let availableIDs = AppData.items.compactMap { value in
                        return value.selected ? nil : value.id
                    }
                    var availableSnapshot = NSDiffableDataSourceSectionSnapshot<ItemsData.ID>()
                    availableSnapshot.append(availableIDs)
                    AppData.dataSelectedSource.apply(availableSnapshot, to: .available, animatingDifferences: true, completion: nil)
                // 아이템이 선택되지 않은 상태라면
                } else {
                    // 선택 가능한 섹션에서 아이템 삭제
                    var availableSnapshot = AppData.dataSelectedSource.snapshot(for: .available)
                    availableSnapshot.delete([itemID])
                    AppData.dataSelectedSource.apply(availableSnapshot, to: .available, animatingDifferences: true, completion: nil)
                    
                    item.selected = true
                    
                    // 선택한 섹션에서 선택한 아이템을 골라내어 추가
                    let selectedIDs = AppData.items.compactMap { value in
                        return value.selected ? value.id : nil
                    }
                    var selectedSnapshot = NSDiffableDataSourceSectionSnapshot<ItemsData.ID>()
                    selectedSnapshot.append(selectedIDs)
                    AppData.dataSelectedSource.apply(selectedSnapshot, to: .selected, animatingDifferences: true, completion: nil)
                }
            }
        }
        
    }
    
}
