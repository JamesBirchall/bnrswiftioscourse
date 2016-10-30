//
//  ItemStore.swift
//  Homepwner
//
//  Created by James Birchall on 29/10/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class ItemStore {
    
    var allItems = [Item]()
    
    
    func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    func moveItemAtIndex(from: Int, to: Int) {
        if from == to {
            return  // no change needed
        }
        
        // clone from item, delete its original then move to new location
        let movedItem = allItems[from]
        allItems.remove(at: from)
        allItems.insert(movedItem, at: to)
    }

    // used before we had add functionality
//    init() {
//        for _ in 0..<5 {
//            let item = createItem()
//            print("Item created: \(item.name)")
//        }
//    }
}