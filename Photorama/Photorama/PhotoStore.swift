//
//  PhotoStore.swift
//  Photorama
//
//  Created by James Birchall on 27/11/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import Foundation

class PhotoStore {
    
    static var requestCounter = 0   // used to record requests made to flickr
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config)
        return urlSession
    }()
    
    func fetchRecentPhotos() {
        let url = FlickrAPI.recentPhotosURL()
        let request = URLRequest(url: url)
        
        print("URL Attempted: \(request)")
        print("Request number this run: \(PhotoStore.requestCounter)")
        
        let task = session.dataTask(with: request, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            PhotoStore.requestCounter += 1  // increment from call made
            
            if let jsonData = data {
                if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
                    print(jsonString)
                }
            } else if let requestError = error {
                print("Error fetching recent photos: \(requestError)")
            } else {
                print("Unexpected error occured.")
            }
        })
        task.resume()   // begin task
    }
}
