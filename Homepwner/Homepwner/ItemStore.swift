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
    
    // Where we can pickup existing store from URL
    let itemArchiveURL: URL = {
        // get an array of documentDirectories
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        let documentDirectory = documentDirectories.first!
        
        let finalURL: URL = documentDirectory.appendingPathComponent("items.archive")
        
        return finalURL
    }() // must have (), this is a closure used to return value of URL hardcoded to items.archive path
    
    // MARK: - Add and Removes
    
    func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.insert(newItem, at: 0)
        
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
    
    func saveChanges() -> Bool {
        
        print("Saving items to \(itemArchiveURL.path).")
        
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path)
    }

    // used before we had add functionality
//    init() {
//        for _ in 0..<5 {
//            let item = createItem()
//            print("Item created: \(item.name)")
//        }
//    }
}
