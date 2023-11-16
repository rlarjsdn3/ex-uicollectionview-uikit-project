//
//  HierarchicalData.swift
//  UICollectionView
//
//  Created by 김건우 on 11/16/23.
//

import UIKit

enum MainSections {
    case main
}

struct MainItems: Identifiable {
    var id = UUID()
    var name: String!
    var options: [MainItems]!
}

struct HierarchicalData {
    var dataSource: UICollectionViewDiffableDataSource<MainSections, MainItems.ID>!
    
    let items = [
        MainItems(name: "Food", options: [
            MainItems(name: "Oatmeal", options: nil),
            MainItems(name: "Bagels", options: nil),
            MainItems(name: "Brownies", options: nil),
            MainItems(name: "Cheese", options: nil),
            MainItems(name: "Cookies", options: nil),
            MainItems(name: "Donuts", options: nil)
        ]),
        MainItems(name: "Beverages", options: [
            MainItems(name: "Coffee", options: nil),
            MainItems(name: "Juice", options: nil),
            MainItems(name: "Lemonade", options: nil)
        ])
    ]
}
