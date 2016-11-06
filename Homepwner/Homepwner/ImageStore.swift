//
//  ImageStore.swift
//  Homepwner
//
//  Created by James Birchall on 06/11/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class ImageStore: NSObject {
    let cache = NSCache<AnyObject, AnyObject>()
    
    func setImage(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as AnyObject)
    }
    
    func imageForKey(key: String) -> UIImage? {
        return cache.object(forKey: key as AnyObject) as? UIImage
    }
    
    func deleteImageForKey(key: String) {
        cache.removeObject(forKey: key as AnyObject)
        print("Image deleted from store...")
    }
}
