//
//  PhotoDataSource.swift
//  Photorama
//
//  Created by James Birchall on 29/11/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource {
    
    var photos = [Photo]()  // where photos will sit during app in existence
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = "UICollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! PhotoCollectionViewCell
        
        let photo = photos[indexPath.row]
        cell.updateWithImage(image: photo.image)  // now have image to use to update imageView.image in cell
        
        return cell
    }
}
