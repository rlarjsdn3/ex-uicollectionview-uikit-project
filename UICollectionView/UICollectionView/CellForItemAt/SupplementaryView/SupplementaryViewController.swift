//
//  SupplementaryViewController.swift
//  UICollectionView
//
//  Created by 김건우 on 11/9/23.
//

import UIKit

class SupplementaryViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let list = MaterialColorDataSource.generateMultiSectionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(FooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "footer")
        
        configureLayout()
    }
    
    func configureLayout() {
        collectionView.collectionViewLayout = createFlowLayout()
    }
    
    func createFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionHeadersPinToVisibleBounds = true
        return flowLayout
    }
    
}

extension SupplementaryViewController: UICollectionViewDelegate { }

extension SupplementaryViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list[section].colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        var backgroundConfig = cell.defaultBackgroundConfiguration()
        backgroundConfig.backgroundColor = list[indexPath.section].colors[indexPath.row]
        cell.backgroundConfiguration = backgroundConfig
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! HeaderCollectionReusableView
            header.headerLabel.text = list[indexPath.section].title
            header.backgroundColor = UIColor.secondarySystemBackground
            return header
        default:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath) as! FooterCollectionReusableView
            footer.footerLabel.text = list[indexPath.section].colors.first?.rgbHexString
            footer.backgroundColor = UIColor.systemMint
            return footer
        }
    }
    
}

extension SupplementaryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
}
