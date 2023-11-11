//
//  PrefetchingViewController.swift
//  UICollectionView
//
//  Created by 김건우 on 11/9/23.
//

import UIKit

class PrefetchingViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var list = Landscape.generateData()
    var downloadTasks = [URLSessionTask]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        configureLayout()
    }
    
    func configureLayout() {
        collectionView.collectionViewLayout = createFlowLayout()
    }
    
    func createFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 15
        flowLayout.minimumInteritemSpacing = 15
        flowLayout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        return flowLayout
    }

}


extension PrefetchingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if let imageView = cell.viewWithTag(777) as? UIImageView {
            if let image = list[indexPath.row].image {
                imageView.image = image
            } else {
                imageView.image = nil
                downloadImage(at: indexPath.item)
            }
        }
        
        return cell
    }
    
}

extension PrefetchingViewController: UICollectionViewDelegate {
    
    // ⭐️ 셀이 보여지기 전에 호출되는 델리게이트 메서드
    // 이 메서드를 구현하지 않으면 재사용 메커니즘에 의해 다시 위로 스크롤하면 로드되는 속도가 느려질 수 있음.
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let imageView = cell.viewWithTag(777) as? UIImageView {
            if let image = list[indexPath.row].image {
                imageView.image = image
            } else {
                imageView.image = nil
            }
        }
    }
    
}

extension PrefetchingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }
        
        let bounds = collectionView.bounds
        var width = (bounds.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right))
        width = (width - (flowLayout.minimumInteritemSpacing * 1)) / 2
        
        return CGSize(width: width, height: width)
    }
    
}

extension PrefetchingViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            downloadImage(at: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            cancelDownload(at: indexPath.item)
        }
    }
    
    
}

extension PrefetchingViewController {
    
    func downloadImage(at index: Int) {
        guard list[index].image == nil else {
            return
        }
        
        let targetUrl = list[index].url
        guard !downloadTasks.contains(where: { $0.originalRequest?.url == targetUrl }) else {
            return
        }
        
        print(#function, index)
        
        let task = URLSession.shared.dataTask(with: targetUrl) { [weak self] (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let data = data, let image = UIImage(data: data), let strongSelf = self {
                strongSelf.list[index].image = image
                let reloadTargetIndexPath = IndexPath(row: index, section: 0)
                DispatchQueue.main.async {
                    if strongSelf.collectionView.indexPathsForVisibleItems.contains(reloadTargetIndexPath) {
                        strongSelf.collectionView.reloadItems(at: [reloadTargetIndexPath])
                    }
                }
                
                strongSelf.completeTask()
            }
        }
        task.resume()
        downloadTasks.append(task)
    }
    
    
    func completeTask() {
        downloadTasks = downloadTasks.filter { $0.state != .completed }
    }
    
    func cancelDownload(at index: Int) {
        let targetUrl = list[index].url
        guard let taskIndex = downloadTasks.firstIndex(where: { $0.originalRequest?.url == targetUrl }) else {
            return
        }
        let task = downloadTasks[taskIndex]
        task.cancel()
        downloadTasks.remove(at: taskIndex)
    }
    
}




