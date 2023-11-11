//
//  ReorderingViewController.swift
//  UICollectionView
//
//  Created by 김건우 on 11/11/23.
//

import UIKit

class ReorderingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var list = MaterialColorDataSource.generateMultiSectionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        collectionView.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: collectionView)
        
        switch sender.state {
        case .began:
            if let indexPath = collectionView.indexPathForItem(at: location) {
                collectionView.beginInteractiveMovementForItem(at: indexPath)
            }
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(location)
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }

}

extension ReorderingViewController: UICollectionViewDelegate { }

extension ReorderingViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list[section].colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = list[indexPath.section].colors[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = list[sourceIndexPath.section].colors.remove(at: sourceIndexPath.item)
        list[destinationIndexPath.section].colors.insert(temp, at: sourceIndexPath.item)
    }
    
}
