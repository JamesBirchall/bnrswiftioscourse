//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by James Birchall on 04/12/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo");
    }

    @NSManaged public var dateTaken: Date
    @NSManaged public var photoID: String
    @NSManaged public var photoKey: String
    @NSManaged public var remoteURL: URL
    @NSManaged public var title: String
    @NSManaged public var viewCount: UInt64
    @NSManaged public var tags: Set<NSManagedObject>

}
