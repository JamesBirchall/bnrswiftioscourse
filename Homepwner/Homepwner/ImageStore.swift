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
        
        // Create full URL for image
        let imageURL = imageURLForKey(key: key)
        
        // turn image into JPEG
//        if let data = UIImageJPEGRepresentation(image, 0.5) {
//            
//            do {
//                try data.write(to: imageURL, options: .atomic)
//            } catch {
//                print("Error writing image to disk: \(error)")
//            }
//        }
        
        // Bronze challenge PNG saving images
        if let data = UIImagePNGRepresentation(image) {
            do {
                try data.write(to: imageURL, options: .atomic)
                print("Written to \(imageURL)")
            } catch {
                print("Error writting image to deisk: \(error)")
            }
        }
    }
    
    func imageForKey(key: String) -> UIImage? {
        //return cache.object(forKey: key as AnyObject) as? UIImage
        
        if let existingImage = cache.object(forKey: key as AnyObject) as? UIImage {
            return existingImage
        }
        
        let imageURL = imageURLForKey(key: key)
        guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as AnyObject)
        return imageFromDisk
    }
    
    func deleteImageForKey(key: String) {
        cache.removeObject(forKey: key as AnyObject)
    
        let imageURL = imageURLForKey(key: key)
        do {
            try FileManager.default.removeItem(at: imageURL)
        } catch {
            print("Error removing file: \(error)")
        }
        
        
    }
    
    func imageURLForKey(key: String) -> URL {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        let documentDirectory = documentDirectories.first!
        
        let finalURL = documentDirectory.appendingPathComponent(key)
        
        return finalURL
    }
}
