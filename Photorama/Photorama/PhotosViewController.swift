//
//  PhotosViewController.swift
//  Photorama
//
//  Created by James Birchall on 14/11/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!   // we unwrap explicitly because it will be connected by time it is to be used by this classes methods - if crashes then we need to know
    var store: PhotoStore!
    var tempPhotoStore: [Photo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchRecentPhotos(completion: {
            (photosResult) -> Void in
            switch photosResult {
            case let .success(photos):
                print("Successfully found \(photos.count) recent photos")
//                for photo in photos {
//                    print("\(photo)")
//                }
                
                self.tempPhotoStore = photos
                print(self.tempPhotoStore?.count ?? "Nothing found in Temp Photo Store")
                
                // lets go capture the Photo images and store them in the Photo Objects
                if let first = photos.first {
                    // lets display the first one on the screen in full view!
                    
                    print("fetching first photo: \(first.photoID) with date: \(first.dateTaken))")
                    
                    self.store.fetchImageForPhoto(photo: first, completion: {
                        (imageResult: PhotoStore.ImageResult) -> Void in
                        switch imageResult {
                        case let .success(image):
                            
                            // lets do this operation on the main thread as its UI related
                            OperationQueue.main.addOperation { self.imageView.image = image }
                        case let .failure(error):
                            print("Error downloading image: \(error)")
                        }
                    })
                }
            case let .failure(error):
                print("Error fetching recent photos: \(error)")
            }
        })
    }

    @IBAction func nextPhotoButton(_ sender: UIBarButtonItem) {
        
        // remove first in index then show first again!
        if tempPhotoStore != nil {
            tempPhotoStore?.remove(at: 0)
        } else {
            print("temp photo store is nil...")
        }
        
//        if (tempPhotoStore?.count)! > 0 {
            if let nextPhoto = tempPhotoStore?.first {
                print("fetching next photo: \(nextPhoto.photoID) with date: \(nextPhoto.dateTaken))")
                self.store.fetchImageForPhoto(photo: nextPhoto, completion: {
                    (imageResult: PhotoStore.ImageResult) -> Void in
                    switch imageResult {
                    case let .success(image):
                        // lets do this operation on the main thread as its UI related
                        OperationQueue.main.addOperation { self.imageView.image = image }
                    case let .failure(error):
                        print("Error downloading image: \(error)")
                    }
                })
//            }
            
        }
    }
}
