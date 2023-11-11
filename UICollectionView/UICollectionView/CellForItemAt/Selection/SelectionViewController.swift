//
//  SelectionViewController.swift
//  UICollectionView
//
//  Created by 김건우 on 11/9/23.
//

import UIKit

class SelectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var list: [MaterialColorDataSource.Color] = {
        (0...2).map { _ in
            MaterialColorDataSource.generateSingleSectionData()
        }.reduce([], +)
    }()
    
    lazy var checkImage: UIImage? = UIImage(systemName: "checkmark.circle")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        configureLayout()
    }
    
    func configureLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionView.collectionViewLayout = flowLayout
    }
    
    func selectRandomItem() {
        let item = Int.random(in: 0..<list.count)
        let targetIndexPath = IndexPath(item: item, section: 0)
        
        // ⭐️ 코드로 셀을 선택하게 되면 관련 델리게이트 메서드가 호출되지 않음.
        collectionView.selectItem(at: targetIndexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func reset() {
        // ⭐️ deselect 메서드를 여러 번 호출하는 것보다, selectItem 메서드에 nil을 전달하는 게 더 좋음.
        collectionView.selectItem(at: nil, animated: true, scrollPosition: .top)
        
        let targetIndexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: targetIndexPath, at: .left, animated: true)
        
        view.backgroundColor = UIColor.systemBackground
    }

}

extension SelectionViewController: UICollectionViewDelegate {
    
    // ⭐️ 셀이 선택되고 난 후, 호출되는 델리게이트 메서드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        view.backgroundColor = list[indexPath.item].color
        
        // ✏️ 뷰의 재사용 메커니즘에 의해, 선택 안한 셀에 체크마크가 표시될 수 있음.
        if let cell = collectionView.cellForItem(at: indexPath) {
            let imageView = cell.viewWithTag(888) as! UIImageView
            imageView.image = checkImage
        }
    }
    
    // ⭐️ 셀의 선택 유무를 결정하는 델리게이트 메서드
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // ⭐️ 셀의 선택 해제 유무를 결정하는 델리게이트 메서드
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // ⭐️ 셀이 선택 해제되고 난 후, 호출되는 델리게이트 메서드
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            let imageView = cell.viewWithTag(888) as! UIImageView
            imageView.image = nil
        }
    }
    
    // ⭐️ 일반적으로 이미지는 기본과 하이라이트 이미지를 동시에 설정함.
    // 컨렉션 뷰는 셀을 클릭하게 되면 해당 셀 내 뷰를 하이라이트 상태로 바꿈.
    // 따라서, 별도 델리게이트 메서드를 작성해주지 않고, 이미지에 하이라이트 이미지를 삽입하는 걸로도 쉽게 구현 가능함.
    
    // ⭐️ 셀의 강조 유무를 결정하는 델리게이트 메서드
    // 셀을 강조할 수 없다면, 선택도 할 수 없음.
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // ⭐️ 셀이 강조되고 난 후, 호출되는 델리게이트 메서드
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.layer.borderWidth = 3.0
        }
    }
    
    // ⭐️ 셀이 강조 해제되고 난 후, 호출되는 델리게이트 메서드
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.layer.borderWidth = 0.0
        }
    }
    
}

extension SelectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        var backgroundConfig = cell.defaultBackgroundConfiguration()
        backgroundConfig.backgroundColor = list[indexPath.item].color
        cell.backgroundConfiguration = backgroundConfig
        return cell
    }
    
}
