//
//  FooterCollectionReusableView.swift
//  UICollectionView
//
//  Created by 김건우 on 11/11/23.
//

import UIKit

class FooterCollectionReusableView: UICollectionReusableView {
        
    var footerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createView() {
        self.addSubview(footerLabel)
        
        footerLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1.0).isActive = true
        footerLabel.trailingAnchor.constraint(equalToSystemSpacingAfter: trailingAnchor, multiplier: 1.0).isActive = true
        footerLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
}
