//
//  UpdateHandlerViewController.swift
//  UICollectionView
//
//  Created by 김건우 on 11/12/23.
//

import UIKit

class UpdateHandlerViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var appData: ApplicationData = ApplicationData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        
        prepareDatasource()
        prepareSnapshot()
        
        configureLayout()
    }
    
    func prepareDatasource() {
        // ⭐️ 셀을 등록하는 과정에서 셀에 관한 모든 걸 정의(UpdateHandler 등)
        let cellRagistration = UICollectionView.CellRegistration<FoodCell, ItemsData.ID> { [unowned self] cell, indexPath, itemID in
            if let item = appData.items.first(where: { $0.id == itemID }) {
                cell.picture.image = UIImage(named: item.image)
            }
            // ⭐️ 셀의 상태가 변할 때마다 호출됨
            cell.configurationUpdateHandler = { cell, state in
                var backgroundConfg = cell.defaultBackgroundConfiguration()
                backgroundConfg.cornerRadius = 10.0
                
                if state.isSelected {
                    backgroundConfg.backgroundColor = UIColor.systemGray5
                } else {
                    backgroundConfg.backgroundColor = UIColor.systemBackground
                }
                cell.backgroundConfiguration = backgroundConfg
            }
        }
        
        appData.dataSource = UICollectionViewDiffableDataSource<Sections, ItemsData.ID>(collectionView: collectionView) { collectionView, indexPath, itemID in
            return collectionView.dequeueConfiguredReusableCell(using: cellRagistration, for: indexPath, item: itemID)
        }
    }
    
    func prepareSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, ItemsData.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(appData.items.map { $0.id })
        appData.dataSource.apply(snapshot)
    }
    
    func configureLayout() {
        collectionView.collectionViewLayout = createFlowLayout()
    }
    
    func createFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return flowLayout
    }
    
}

extension UpdateHandlerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
}
