//
//  CutomItemViewController.swift
//  UICollectionView
//
//  Created by 김건우 on 11/9/23.
//

import UIKit

class CutomItemViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let list = MaterialColorDataSource.generateSingleSectionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
}

extension CutomItemViewController: UICollectionViewDelegate { }

extension CutomItemViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.colorView.backgroundColor = list[indexPath.item].color
        cell.hexLabel.text = list[indexPath.item].hex
        cell.nameLabel.text = list[indexPath.item].title
        
        return cell
    }
    
}

extension CutomItemViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = bounds.width
        return CGSize(width: width, height: 85)
    }
    
}
