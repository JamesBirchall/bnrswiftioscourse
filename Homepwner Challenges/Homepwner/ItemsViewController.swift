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
    
    let noMoreItemString = "No more items"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get status bar height and use to set inset at top of screen
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        
        // silver challenge - add final section and empty row!
        let emptyItem = Item(name: noMoreItemString, valueInDollars: 0, serialNumber: nil)
        itemSections.append(ItemSectionStore(headerName: noMoreItemString, itemStores: [emptyItem]))
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        let section = itemSections[indexPath.section]
        let item = section.itemStores[indexPath.row]
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
        let image = UIImage(named: "itemBackground")
        
        imageView.image = image
        cell.backgroundView = UIView()
        cell.backgroundView?.addSubview(imageView)
        
        cell.textLabel?.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.backgroundColor = UIColor.clear
        cell.detailTextLabel?.textColor = UIColor.white
        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // set height generally to 60, set to lower if its the section with None in!
        var height = 60.0
        
        let section = itemSections[indexPath.section]
        let item = section.itemStores[indexPath.row]
        
        if item.name == noMoreItemString {
            height = 40
            print("Height for this row changed: \(section.headerName)")
        }
        
        return CGFloat(height)
    }
}

