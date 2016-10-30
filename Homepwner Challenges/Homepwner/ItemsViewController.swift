//
//  ViewController.swift
//  Homepwner
//
//  Created by James Birchall on 29/10/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    //var itemStore: ItemStore!
    var itemSections: [ItemSectionStore]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get status bar height and use to set inset at top of screen
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        let section = itemSections[indexPath.section]
        let item = section.itemStores[indexPath.row]
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = itemSections[section]
        let countOfItems = section.itemStores.count
        
        return countOfItems
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return itemSections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = itemSections[section]
        
        return section.headerName
    }
    
}

