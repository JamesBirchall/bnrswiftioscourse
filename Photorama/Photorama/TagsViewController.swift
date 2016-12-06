//
//  TagsViewController.swift
//  Photorama
//
//  Created by James Birchall on 06/12/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit
import CoreData

class TagsViewController: UITableViewController {

    var store: PhotoStore!
    var photo: Photo!
    
    var selectedIndexPaths = [IndexPath]()
    
    let tagsDataSource = TagDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = tagsDataSource
        tableView.delegate = self
        updateTags()    // go get the core data object data for tags
    }
    
    func updateTags() {
        let sortByNameAscending = NSSortDescriptor(key: "name", ascending: true)
        
        let tags = try! store.fetchMainQueueTags(predicate: nil, sortDescriptors: [sortByNameAscending])
        
        tagsDataSource.tags = tags
        
        for tag in photo.tags {
            if let index = tagsDataSource.tags.index(of: tag) {
                let indexPath = IndexPath(row: index, section: 0)
                selectedIndexPaths.append(indexPath)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = tagsDataSource.tags[indexPath.row]
        
        if let index = selectedIndexPaths.index(of: indexPath) {
            selectedIndexPaths.remove(at: index)
            photo.removeTagObject(tag: tag)
        } else {
            selectedIndexPaths.append(indexPath)
            photo.addTagObject(tag: tag)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        // save changes
        do {
            try store.coreDataStack.saveChanges()
        } catch let error {
            print("Core Data save failed: \(error)")
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if selectedIndexPaths.index(of: indexPath) != nil {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    @IBAction func done() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addNewTag() {
        let alertController = UIAlertController(title: "Add Tag", message: nil, preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: {
            (textField) -> Void in
            
            textField.placeholder = "tag name..."
            textField.autocapitalizationType = .words
        })
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (action) -> Void in
            // more code here to add tag!
            
            if let tagName = alertController.textFields?.first?.text {
                let context = self.store.coreDataStack.mainQueueContext
                let newTag = NSEntityDescription.insertNewObject(forEntityName: "Tag", into: context)
                newTag.setValue(tagName, forKey: "name")
                
                do {
                    try self.store.coreDataStack.saveChanges()
                } catch let error {
                    print("Core Data save Failed: \(error)")
                }
                self.updateTags()
                //self.tableView.reloadSections(IndexSet(index: 0), with: .automatic)
                self.tableView.reloadData() // may be overkill.
            }
        })
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
