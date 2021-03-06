//
//  FlickrAPI.swift
//  Photorama
//
//  Created by James Birchall on 14/11/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import Foundation
import CoreData


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
    
    static func photosFromJSONData(data: Data, inContext context: NSManagedObjectContext) -> PhotoResult {
        do {
            let jsonObject: AnyObject = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
            
            //print(jsonObject)
            //print(".........Break of JSON Object.........")
            guard let jsonDictionary = jsonObject as? [String:AnyObject] else { return .failure(FlickrError.InvalidJSONData) }
//            print(jsonDictionary)
//            print(".........Break of JSON Dictionary.........")
            guard let photos = jsonDictionary["photos"] as? [String:AnyObject] else { return .failure(FlickrError.InvalidJSONData) }
//            print(photos)
//            print(".........Break of Photos Dictionary.........")
            guard let photosArray = photos["photo"] as? [[String:AnyObject]] else { return .failure(FlickrError.InvalidJSONData) }
//            print(photosArray)
//            print(".........Break of Photo Array.........")
            
            var finalPhotos = [Photo]() // Photo array we need to add to later
            for photoJSON in photosArray {
                if let photo = photosFromJSONObject(json: photoJSON, inContext: context) {
//                    print(photo)
//                    print("...Photo Data Printed...")
                    finalPhotos.append(photo)
                }
            }
            
//            for photo in finalPhotos {
//                print(photo.remoteURL)
//            }
//            print("Final Photos All Printed, count is \(finalPhotos.count)")
            
            if finalPhotos.count == 0 && photosArray.count > 0 {
                // likely wasn't able to parse format or data was missing necessary parameters e.g. URL
                return .failure(FlickrError.InvalidJSONData)
            }

            return .success(finalPhotos)
        } catch {
            return .failure(error)
        }
    }
    
    private static func photosFromJSONObject(json: [String:AnyObject], inContext context: NSManagedObjectContext) -> Photo? {
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
        
        // Core Data - Lets re-use photos we already have!
        let fetchRequest = NSFetchRequest<Photo>(entityName: "Photo")
        let predicate = NSPredicate.init(format: "photoID == \(photoID)", argumentArray: nil)
        fetchRequest.predicate = predicate
        
        var fetchedPhotos: [Photo]!
        context.performAndWait {
            fetchedPhotos = try! context.fetch(fetchRequest)
        }
        
        if fetchedPhotos.count > 0 {
            return fetchedPhotos.first
        }
        
        //return Photo(title: title, remoteURL: url, photoID: photoID, dateTaken: dateTaken)
        
        var photo: Photo!
        context.performAndWait {
            photo = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as! Photo
            photo.title = title
            photo.photoID = photoID
            photo.remoteURL = url
            photo.dateTaken = dateTaken
            photo.viewCount = 0 // start with no views
            photo.favourite = false // start with no favourites!
        }
        
        return photo
    }
}
