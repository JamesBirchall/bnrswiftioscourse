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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchRecentPhotos()
    }
}
