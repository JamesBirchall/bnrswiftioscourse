//
//  ViewController.swift
//  Homepwner
//
//  Created by James Birchall on 29/10/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    @IBOutlet weak var editButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get status bar height and use to set inset at top of screen
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // configure cell and return it!
        
        //let cell = UITableViewCell(style: .value1, reuseIdentifier: "ItemCell")
        
        //
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let item = itemStore.allItems[indexPath.row]

        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        
        return cell
    }
    
    @IBAction func addNewItem() {
        
        let newItem = itemStore.createItem()    // setup a new model object to match adding row in second
        
        // if we get an index for this new item in the store, add a new row to tableView to keep in sync
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0) // only 1 section in this app!
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleEditingMode(sender: UIButton) {
        if isEditing {
            sender.setTitle("Edit", for: .normal)
            setEditing(false, animated: true)
        } else {
            sender.setTitle("Done", for: .normal)
            setEditing(true, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // delete routine
        if editingStyle == .delete {
            // remove model object at exact location
            itemStore.allItems.remove(at: indexPath.row)
            // remove from tableview to keep in sync
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // reset editing button and isEditing Mode back to not Editing tableview
            if itemStore.allItems.count == 0 {
//                editButton.setTitle("Edit", for: .normal)
//                setEditing(false, animated: true)
                toggleEditingMode(sender: editButton)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // move in the object model as well
        itemStore.moveItemAtIndex(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func deleteItem(itemPosition: Int) {
        itemStore.allItems.remove(at: itemPosition)
    }
}

