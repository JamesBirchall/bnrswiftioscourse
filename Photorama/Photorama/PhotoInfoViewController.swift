//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by James Birchall on 29/11/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController{
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var photoURL: UILabel!
    @IBOutlet weak var dateTaken: UILabel!
    
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
    }
}
