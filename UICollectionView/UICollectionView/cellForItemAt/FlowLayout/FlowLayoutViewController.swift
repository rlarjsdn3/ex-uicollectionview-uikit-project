//
//  FlowLayoutViewController.swift
//  UICollectionView
//
//  Created by 김건우 on 11/9/23.
//

import UIKit

class FlowLayoutViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let list = MaterialColorDataSource.generateMultiSectionData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configureLayout()
    }
    
    @IBAction func toggleButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    func configureLayout() {
        collectionView.collectionViewLayout = createFlowLayout()
    }
    
    func createFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        // ⭐️ 아이템 간 사이 최소 간격 설정
        // 수직・수평 스크롤에 따라 최소 간격 방향이 달라짐
        // (수직 스크롤 - 수평 간격, 수평 스크롤 - 수직 간격)
        layout.minimumInteritemSpacing = 5.0
        // ⭐️ 아이템을 스크롤 방향 간격 설정
        layout.minimumLineSpacing = 5.0
        // ⭐️ 섹션 패딩 값 설정
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5)
        
        return layout
    }

}

extension FlowLayoutViewController: UICollectionViewDelegate { }

extension FlowLayoutViewController: UICollectionViewDataSource {
    
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

extension FlowLayoutViewController: UICollectionViewDelegateFlowLayout {
    
    // ⭐️ 델리게이트 메서드 호출 순서
    // #1 → #4 → #2 → #3
    // 주의해야 할 점은 FlowLayout 구성에 필요한 값(InterItem, LineSpacing 등)은 아래 델리게이트 메서드로부터 가져오는 게 아닌 collectionViewLayout에서 곧바로 가져옴!
    // 따라서, 값을 필요로 하는 경우, 직접 델리게이트 메서드를 호출하거나, 미리 UICollectionViewFlowLayout 객체에 값을 설정해놔야 함.
    
    // 아래 예제에서는 미리 UICollectionViewFlowLayout 객체에 값을 설정해놨으므로, 별도 델리게이트 메서드를 필요 없음.
    
    // ⭐️ 플로우 레이아웃에서 각 아이템의 크기를 계산해서 반환하는 델리게이트 메서드
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // for Debug
        print("#1", #function)
        
        // UICollectionViewLayout을 UICollectionViewFlowLayout으로 다운 캐스팅하기
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        
        // 내비게이션 탑바 영역을 뺀 컬렉션 뷰의 가로・세로 값 구하기
        var bounds = collectionView.bounds
        // ❗️ bounds.origin.y 값이 -149인 이유: 상위 뷰 입장에서 컬렉션 뷰를 바라볼 때, y좌표가 -149 위치에서 시작하기 때문임. (다시 확인 필요)
        bounds.size.height += bounds.origin.y
        
        // 섹션 패딩 값을 뺀 실질적인 컬렉션 뷰의 가로・세로 값 구하기
        var width = (bounds.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right))
        var height = (bounds.height - (flowLayout.sectionInset.top + flowLayout.sectionInset.bottom))
        
        switch flowLayout.scrollDirection {
        case.vertical:
            height = (height - (flowLayout.minimumLineSpacing * 4)) / 5
            
            if indexPath.item > 0 {
                width = (width - (flowLayout.minimumInteritemSpacing * 2)) / 3
            }
        case .horizontal:
            width = (width - (flowLayout.minimumLineSpacing * 2) / 3)
        default:
            break
        }
        
        return CGSize(width: width.rounded(.down), height: height.rounded(.down))
    }
    
    // ⭐️ 아이템 간 사이 최소 간격을 설정하는 델리게이트 메서드
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        // for Debug
//        print("#2", #function)
//        
//        return 5.0
//    }
    
    // ⭐️ 스크롤 방향 간격을 설정하는 델리게이트 메서드
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        // for Debug
//        print("#3", #function)
//        
//        return 5.0
//    }
    
    // ⭐️ 섹션 패딩 값을 설정하는 델리게이트 메서드
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        // for Debug
//        print("#4", #function)
//        
//        return UIEdgeInsets(top: 0.0, left: 5.0, bottom: 5.0, right: 5.0)
//    }
    
    
}
