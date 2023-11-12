//
//  MyHeaderView.swift
//  UICollectionView
//
//  Created by 김건우 on 11/12/23.
//

import UIKit

class MyHeaderView: UICollectionReusableView {
    
    var pictureView = UIImageView()
    var textView = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        pictureView.contentMode = .scaleAspectFill
        self.addSubview(pictureView)
        
        pictureView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        pictureView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        pictureView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        pictureView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .title1)
        self.addSubview(textView)
        
        textView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
