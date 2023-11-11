//
//  SelfSizingViewController.swift
//  UICollectionView
//
//  Created by 김건우 on 11/9/23.
//

import UIKit

class SelfSizingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var list: [String] = {
        let lipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
        return lipsum.split(separator: " ").map { String($0) }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configureLayout()
    }
    
    func configureLayout() {
        collectionView.collectionViewLayout = createFlowLayout()
    }
    
    func createFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return flowLayout
    }

}

extension SelfSizingViewController: UICollectionViewDelegate { }

extension SelfSizingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let textLabel = cell.viewWithTag(999) as? UILabel {
            textLabel.text = list[indexPath.item]
        }
        return cell
    }
    
}
