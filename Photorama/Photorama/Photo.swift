//
//  Photo+CoreDataClass.swift
//  Photorama
//
//  Created by James Birchall on 04/12/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import Foundation
import CoreData
import UIKit


public class Photo: NSManagedObject {
    
    var image: UIImage?    
    
    public override func awakeFromInsert() {
        // when objects added to dabatase they are sent this method
        super.awakeFromInsert()
        
        title = ""
        photoID = ""
        remoteURL = URL(fileURLWithPath: "~")
        photoKey = UUID.init().uuidString
        dateTaken = Date.init()
        viewCount = 0  
    }

    func addTagObject(tag: NSManagedObject) {
        let currentTags = mutableSetValue(forKey: "tags")
        currentTags.add(tag)
    }
    
    func removeTagObject(tag: NSManagedObject) {
        let currentTags = mutableSetValue(forKey: "tags")
        currentTags.remove(tag)
    }
}

