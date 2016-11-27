//
//  Photo.swift
//  Photorama
//
//  Created by James Birchall on 27/11/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import Foundation

class Photo: CustomStringConvertible {
    let title: String
    let remoteURL: URL
    let photoID: String
    let dateTaken: Date
    
    init(title: String, remoteURL: URL, photoID: String, dateTaken: Date) {
        self.title = title
        self.remoteURL = remoteURL
        self.photoID = photoID
        self.dateTaken = dateTaken
    }
    
    var description: String {
        return "\(title) | \(photoID) | \(dateTaken) | \(remoteURL)"
    }
}
