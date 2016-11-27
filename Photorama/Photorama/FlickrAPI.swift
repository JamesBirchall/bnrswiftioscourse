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

enum PhotoResult {
    case success([Photo])
    case failure(Error)
}

enum FlickrError: Error {
    case InvalidJSONData
}

private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-DD HH:mm:ss"
    return formatter
}

struct FlickrAPI {
    
    // limit static value type variable to this file only
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = {
        () -> String in
        // get API key from file which needs to contain API key for user
        if let filePath = Bundle.main.path(forResource: "apikey", ofType: nil) {
            //return filePath
            
            if let apiKey = try? String(contentsOfFile: filePath) {
                return apiKey
            }
            
            print("Problem opening file")
            return ""
        } else {
            print("No APIKey detected - check bundle for 'apikey' file.")
            return ""
        }
    }()
    
    private static func flickrURL(_ method: method, parameters: [String: String]?) -> URL {
        
        var components = URLComponents(string: baseURLString)
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = ["method": method.rawValue,
                          "format":"json",
                          "nojsoncallback":"1",
                          "api_key":FlickrAPI.APIKey] as [String : Any]
        
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
    
    static func photosFromJSONData(data: Data) -> PhotoResult {
        do {
            let jsonObject: AnyObject = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            
            guard
                let jsonDictionary = jsonObject as? [String:AnyObject],
                let photos = jsonDictionary["photos"] as? [String:AnyObject],
                let photosArray = photos["photo"] as? [[String:AnyObject]] else {
                return .failure(FlickrError.InvalidJSONData)
            }
            
            var finalPhotos = [Photo]() // Photo array we need to add to later
            for photoJSON in photosArray {
                if let photo = photosFromJSONObject(json: photoJSON) {
                    finalPhotos.append(photo)
                }
            }
            
            if finalPhotos.count == 0 && photosArray.count > 0 {
                // likely wasn't able to parse format
                return .failure(FlickrError.InvalidJSONData)
            }
            
            // delete these bits!!
            let arrayPhoto: [Photo] = [Photo.init(title: "?", remoteURL: FlickrAPI.recentPhotosURL(), photoID: "?", dateTaken: Date())]
            return .success(arrayPhoto)
        } catch {
            return .failure(error)
        }
    }
    
    private static func photosFromJSONObject(json: [String:AnyObject]) -> Photo? {
        guard
            let photoID = json["id"] as? String,
            let title = json["title"] as? String,
            let dateString = json["datetaken"] as? String,
            let photoURL = json["url_h"] as? String,
            let url = URL(string: photoURL),
            let dateTaken = dateFormatter.date(from: dateString)
            else {
                return nil  // not enough info to construct Photo
        }
        
        return Photo(title: title, remoteURL: url, photoID: photoID, dateTaken: dateTaken)
    }
}
