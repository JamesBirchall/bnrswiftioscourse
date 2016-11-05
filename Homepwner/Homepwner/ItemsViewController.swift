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
        
        tableView.rowHeight = 65
        
        // add a final row for No More Items
//        let itemNoMore = Item(name: "No More Items!", valueInDollars: 0, serialNumber: nil)
//        itemStore.allItems.append(itemNoMore)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // configure cell and return it!
        
        //let cell = UITableViewCell(style: .value1, reuseIdentifier: "ItemCell")
        
        // as! ItemCell needed to make sure we can use subclass properties
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        // update labels for font changes
        cell.updateLabels()
        
        let item = itemStore.allItems[indexPath.row]

//        cell.textLabel?.text = item.name
//        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
        
        cell.nameLabel.text = item.name
        cell.detailLabel.text = item.serialNumber
        cell.priceLabel.text = "$\(item.valueInDollars)"
        
        // green or red? - bronze challenge
        if item.valueInDollars >= 50 {
            cell.priceLabel.textColor = UIColor.red
        } else {
            cell.priceLabel.textColor = UIColor.green
        }
        
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
            
            // create alert and get answer before proceeding
            let title = "Delete \(itemStore.allItems[indexPath.row].name)?"
            let message = "Are you sure you want to delete this item?"
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: {
              // code here for handling deletion then!
                (action) -> Void in
                // remove model object at exact location
                self.itemStore.allItems.remove(at: indexPath.row)
                // remove from tableview to keep in sync
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                // reset editing button and isEditing Mode back to not Editing tableview
                if self.itemStore.allItems.count == 0 {
                    //                editButton.setTitle("Edit", for: .normal)
                    //                setEditing(false, animated: true)
                    self.toggleEditingMode(sender: self.editButton)
                }
            })
            alertController.addAction(deleteAction)
            
            // present the alert controller
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        // move in the object model as well
        itemStore.moveItemAtIndex(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
//    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        if indexPath.row == (itemStore.allItems.count - 1) {
//            return UITableViewCellEditingStyle.none
//        } else {
//            return UITableViewCellEditingStyle.delete
//        }
//    }
    
//    // silver challenge
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        if indexPath.row == (itemStore.allItems.count - 1) {
//            return false
//        } else {
//            return true
//        }
//    }
    
    // bronze challenge - change delete button title
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    // gold challenge - stops movement to final row by placing 1 before it!
//    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
//
//        if sourceIndexPath.row < proposedDestinationIndexPath.row {
//            if proposedDestinationIndexPath.row == (itemStore.allItems.count-1) {
//                return IndexPath(row: (proposedDestinationIndexPath.row - 1), section: 0)
//            }
//        }
//        
//        return proposedDestinationIndexPath
//    }
    
    func deleteItem(itemPosition: Int) {
        itemStore.allItems.remove(at: itemPosition)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItem" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
            }
        }
    }
    
    // deal with changes from detail view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

}

