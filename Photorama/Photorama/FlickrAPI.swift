//
//  FlickrAPI.swift
//  Photorama
//
//  Created by James Birchall on 14/11/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import Foundation


// 3600 calls per hour limited - lets keep a count as well for this reason with hourly reset
// could use a peristsent store in NSUserDefaults quite simply and keep it updated when app makes
// calls - if over the limit it should not be allowed
// add date time/stamp and check for hour to pass.

enum method: String {
    case recentPhotos = "flickr.photos.getRecent"
}

struct FlickrAPI {
    
    // limit static value type variable to this file only
    private static let baseURLString = "https://api.flickr.com/services/rest/"
    private static let APIKey = {
        () -> String in
        // get API key from file which needs to contain API key for user
        if let filePath = Bundle.main.path(forResource: "apikey", ofType: nil) {
            return filePath
        } else {
            print("No APIKey detected - check bundle for apikey file.")
            return ""
        }
    }
    
    private static func flickrURL(_ method: method, parameters: [String: String]?) -> URL {
        
        var components = URLComponents(string: baseURLString)
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = ["method": method.rawValue,
                          "format":"json",
                          "nojsoncallback":"1",
                          "api_key":APIKey] as [String : Any]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value as? String)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components?.queryItems = queryItems
        
        return (components?.url!)!
    }
    
    static func recentPhotosURL() -> URL {
        return flickrURL(.recentPhotos, parameters: ["extras" : "url_h,date_taken"])
    }
}
