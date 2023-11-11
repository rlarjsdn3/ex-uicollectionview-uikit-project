//
//  CellRagistrationViewController.swift
//  UICollectionView
//
//  Created by 김건우 on 11/11/23.
//

import UIKit

class CellRagistrationViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var appData: ApplicationData = ApplicationData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // ⭐️ 컬렉션 뷰에 셀 등록
        // 제네릭 타입은 <셀 타입, 셀 고유 ID>
        let cellRagistration = UICollectionView.CellRegistration<FoodCell, ItemsData.ID> { [unowned self] cell, indexPath, itemID in
            if let item = appData.items.first(where: { $0.id == itemID }) {
                cell.picture.image = UIImage(named: item.image)
            }
        }
        // ⭐️ 데이터를 관리하고, 컬렉션 뷰에 셀을 전달
        // 제네릭 타입은 <섹션 고유 ID, 셀 고유 ID>
        appData.dataSource = UICollectionViewDiffableDataSource<Sections, ItemsData.ID>(collectionView: collectionView) { collectionView, indexPath, itemID in
            return collectionView.dequeueConfiguredReusableCell(using: cellRagistration, for: indexPath, item: itemID)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Sections, ItemsData.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(appData.items.map { $0.id })
        appData.dataSource.apply(snapshot)
    }

}
