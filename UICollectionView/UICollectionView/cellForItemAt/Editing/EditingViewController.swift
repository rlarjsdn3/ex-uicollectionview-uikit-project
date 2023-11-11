//
//  EditingViewController.swift
//  UICollectionView
//
//  Created by 김건우 on 11/9/23.
//

import UIKit

class EditingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedList = [UIColor]()
    var list = MaterialColorDataSource.generateMultiSectionData()
    
    // ⭐️ 모델 데이터를 먼저 삭제하고, 컬렉션 뷰에서 삭제
    func emptySelectedList() {
        selectedList.removeAll()
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    
    
    func insertSection() {
        let section = MaterialColorDataSource.Section()
        list.insert(section, at: 0)
        collectionView.insertSections(IndexSet(integer: 1))
    }
    
    
    func deleteSecondSection() {
        list.remove(at: 0)
        collectionView.deleteSections(IndexSet(integer: 1))
    }
    
    
    func moveSecondSectionToThird() {
        let temp = list.remove(at: 0)
        list.insert(temp, at: 1)
        collectionView.moveSection(1, toSection: 2)
    }
    
    
    func performBatchUpdates() {
        // 삭제는 내림차순으로 해야 함
        let deleteIndexPaths = (0..<4)
            .map { _ in Int.random(in: 0..<list[0].colors.count) }
            .sorted(by: >)
            .map { IndexPath(item: $0, section: 1) }
        
        // 추가는 오름차순으로 해야 함
        let insertIndexPaths = (0..<4)
            .map { _ in Int.random(in: 0..<list[0].colors.count) }
            .sorted(by: <)
            .map { IndexPath(item: $0, section: 1) }
        
        deleteIndexPaths.forEach { list[0].colors.remove(at: $0.item) }
        insertIndexPaths.forEach { list[0].colors.insert(UIColor.random, at: $0.item)  }
        
        collectionView.performBatchUpdates {
            collectionView.deleteItems(at: deleteIndexPaths)
            collectionView.insertItems(at: insertIndexPaths)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configureLayout()
    }
    
    @IBAction func MenuPressed(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let emptyListAction = UIAlertAction(title: "Empty Selected List", style: .default) { [weak self] (action) in
            self?.emptySelectedList()
        }
        actionSheet.addAction(emptyListAction)
        
        let insertSectionAction = UIAlertAction(title: "Insert Section", style: .default) { [weak self] (action) in
            self?.insertSection()
        }
        actionSheet.addAction(insertSectionAction)
        
        let delectSecondSectionAction = UIAlertAction(title: "Delete Second Section", style: .default) { [weak self] (action) in
            self?.deleteSecondSection()
        }
        actionSheet.addAction(delectSecondSectionAction)
        
        let moveSectionAction = UIAlertAction(title: "Move Second Section to Third", style: .default) { [weak self] (action) in
            self?.moveSecondSectionToThird()
        }
        actionSheet.addAction(moveSectionAction)
        
        let batchUpdatesAction = UIAlertAction(title: "Perform Batch Update", style: .default) { [weak self] (action) in
            self?.performBatchUpdates()
        }
        actionSheet.addAction(batchUpdatesAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        if let pc = actionSheet.popoverPresentationController {
            pc.barButtonItem = navigationItem.rightBarButtonItem
        }
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func configureLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        // ⭐️ header 사이즈를 설정해줘야 헤더가 정상적으로 표시됨.
        flowLayout.headerReferenceSize = CGSize(width: collectionView.bounds.width, height: 50)
        flowLayout.sectionHeadersPinToVisibleBounds = true
        collectionView.collectionViewLayout = flowLayout
    }

}

extension EditingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // ⭐️ 모델 데이터를 먼저 삭제하고, 컬렉션 뷰에서 삭제
            selectedList.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
        } else {
            let sourceIndexPath = indexPath
            let destinationIndexPath = IndexPath(item: selectedList.count, section: 0)
            
            let deletedItem = list[indexPath.section - 1].colors.remove(at: indexPath.item)
            
            selectedList.append(deletedItem)
            collectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath)
        }
    }
    
}

extension EditingViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return list.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return selectedList.count
        }
        return list[section - 1].colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.backgroundColor = selectedList[indexPath.item]
        default:
            cell.backgroundColor = list[indexPath.section - 1].colors[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderEditingCollectionReusableView

        if indexPath.section == 0 {
            header.titleLabel.text = "선택한 셀"
        } else {
            header.titleLabel.text = list[indexPath.section - 1].title
        }
        header.backgroundColor = UIColor.secondarySystemBackground
        return header
    }
    
}

extension UIColor {
    
    static var random: UIColor {
        let r = CGFloat.random(in: 1..<256) / 255
        let g = CGFloat.random(in: 1..<256) / 255
        let b = CGFloat.random(in: 1..<256) / 255
        
        return UIColor(displayP3Red: r, green: g, blue: b, alpha: 1.0)
    }
    
}
