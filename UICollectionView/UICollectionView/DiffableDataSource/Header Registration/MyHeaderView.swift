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
        
        pictureView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0).isActive = true
        pictureView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0).isActive = true
        pictureView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0).isActive = true
        pictureView.widthAnchor.constraint(equalTo: pictureView.heightAnchor, multiplier: 1.0).isActive = true
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .title2)
        self.addSubview(textView)
        
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8.0).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8.0).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16.0).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
