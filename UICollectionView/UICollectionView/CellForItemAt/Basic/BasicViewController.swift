//
//  BasicViewController.swift
//  UICollectionView
//
//  Created by 김건우 on 11/9/23.
//

import UIKit

class BasicViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var list = MaterialColorDataSource.generateMultiSectionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension BasicViewController: UICollectionViewDelegate { }

extension BasicViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list[section].colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        var backgroundConfig = cell.defaultBackgroundConfiguration()
        backgroundConfig.backgroundColor = list[indexPath.section].colors[indexPath.item]
        cell.backgroundConfiguration = backgroundConfig
        return cell
    }
    
}
