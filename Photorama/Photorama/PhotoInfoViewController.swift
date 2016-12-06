//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by James Birchall on 29/11/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photoURL: UILabel!
    @IBOutlet weak var dateTaken: UILabel!
    @IBOutlet weak var viewCount: UILabel!
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-DD HH:mm:ss"
        return formatter
    }
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // update labels
        photoURL.text = photo.remoteURL.absoluteString
        dateTaken.text = dateFormatter.string(from: photo.dateTaken as Date)
        photo.viewCount += 1    // viewed once more!
        self.viewCount.text = "Views: \(photo.viewCount)"
        
        store.fetchImageForPhoto(photo: photo, completion: {
            (result) -> Void in
            switch result {
            case .success(let image):
                OperationQueue.main.addOperation {
                    self.imageView.image = image
                }
            case .failure(let error):
                print("Error fetching the image: \(error)")
            }
        })
        
        // lets make sure that view Count is updated then the object context is saved
        // otherwise it increased objects viewCOunt in memory but is not saved
        do {
            try store.coreDataStack.saveChanges()
        } catch {
            print("Could not save the changes: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTags" {
            let navController = segue.destination as! UINavigationController
            let tagController = navController.topViewController as! TagsViewController
            
            tagController.store = store
            tagController.photo = photo
        }
    }
}
