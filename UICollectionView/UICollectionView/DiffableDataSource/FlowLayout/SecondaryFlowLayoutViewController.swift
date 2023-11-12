//
//  SecondaryFlowLayoutViewController.swift
//  UICollectionView
//
//  Created by 김건우 on 11/12/23.
//

import UIKit

class SecondaryFlowLayoutViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var appData: ApplicationData = ApplicationData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        flowLayout.itemSize = CGSize(width: 100, height: 100)
//        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        collectionView.delegate = self
        
        prepareDatasource()
        prepareSnapshot()
    }
    
    func prepareDatasource() {
        let cellRagistration = UICollectionView.CellRegistration<FoodCell, ItemsData.ID> { [unowned self] cell, indexPath, itemID in
            if let item = appData.items.first(where: { $0.id == itemID }) {
                cell.picture.image = UIImage(named: item.image)
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
    
}

extension SecondaryFlowLayoutViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 146
        var height: CGFloat = 100
        
        if indexPath.item % 3 == 0 {
            width = 343
            height = 200
        }
        // 스토리보드에서 CollectionView의 Estimated Size를 None으로 변경해야 함.
        return CGSize(width: width, height: height)
    }
    
}
