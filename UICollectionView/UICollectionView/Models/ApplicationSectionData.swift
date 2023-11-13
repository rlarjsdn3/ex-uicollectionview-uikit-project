//
//  SectionData.swift
//  UICollectionView
//
//  Created by 김건우 on 11/13/23.
//

import UIKit

class AlphabetSections: Identifiable {
    var id: UUID = UUID()
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
class FoodsData: Identifiable {
    var id: UUID = UUID()
    var name: String
    var image: String
    var calories: Int
    var selected: Bool
    var section: String
    
    init(_ name: String, _ image: String, _ calories: Int, _ selected: Bool, _ section: String) {
        self.name = name
        self.image = image
        self.calories = calories
        self.selected = selected
        self.section = section
    }
}
struct ApplicationSectionData {
    var dataSource: UICollectionViewDiffableDataSource<AlphabetSections.ID, FoodsData.ID>!
    var sections: [AlphabetSections] = []
    var items: [FoodsData] = []
    
    init() {
        sections.append(contentsOf: [AlphabetSections(name: "B"), AlphabetSections(name: "C"), AlphabetSections(name: "D"), AlphabetSections(name: "G"), AlphabetSections(name: "J"), AlphabetSections(name: "L"), AlphabetSections(name: "M"), AlphabetSections(name: "O"), AlphabetSections(name: "P"), AlphabetSections(name: "T"), AlphabetSections(name: "Y")])
        items.append(contentsOf: [FoodsData("Bagels", "bagels", 250, false, "B"), FoodsData("Brownies", "brownies", 466, false, "B"), FoodsData("Butter", "butter", 717, false, "B")])
        items.append(contentsOf: [FoodsData("Cheese", "cheese", 402, false, "C"), FoodsData("Coffee", "coffee", 0, false, "C"), FoodsData("Cookies", "cookies", 502, false, "C")])
        items.append(contentsOf: [FoodsData("Donuts", "donuts", 452, false, "D")])
        items.append(contentsOf: [FoodsData("Granola", "granola", 471, false, "G")])
        items.append(contentsOf: [FoodsData("Juice", "juice", 23, false, "J")])
        items.append(contentsOf: [FoodsData("Lemonade", "lemonade", 40, false, "L"), FoodsData("Lettuce", "lettuce", 15, false, "L")])
        items.append(contentsOf: [FoodsData("Milk", "milk", 42, false, "M")])
        items.append(contentsOf: [FoodsData("Oatmeal", "oatmeal", 68, false, "O")])
        items.append(contentsOf: [FoodsData("Potatoes", "potato", 77, false, "P")])
        items.append(contentsOf: [FoodsData("Tomatoes", "tomato", 18, false, "T")])
        items.append(contentsOf: [FoodsData("Yogurt", "yogurt", 59, false, "Y")])
    }
}
var appSectionData: ApplicationSectionData = ApplicationSectionData()
