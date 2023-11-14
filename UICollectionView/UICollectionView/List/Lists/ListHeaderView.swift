//
//  ListHeaderView.swift
//  UICollectionView
//
//  Created by 김건우 on 11/14/23.
//

import UIKit

class ListHeaderView: UICollectionReusableView {
        
    var textView = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .headline)
        self.addSubview(textView)
        
        textView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
