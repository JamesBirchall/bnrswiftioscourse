//
//  PhotoStore.swift
//  Photorama
//
//  Created by James Birchall on 27/11/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

class PhotoStore {
    
    enum ImageResult {
        case success(UIImage)
        case failure(Error)
    }
    
    enum PhotoError: Error {
        case ImageCreationError
    }
    
    static var requestCounter = 0   // used to record requests made to flickr
    
    let session: URLSession = {
        let config = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config)
        return urlSession
    }()
    
//    func fetchRecentPhotos() {
//        let url = FlickrAPI.recentPhotosURL()
//        let request = URLRequest(url: url)
//        
//        print("URL Attempted: \(request)")
//        print("Request number this run: \(PhotoStore.requestCounter)")
//        
//        let task = session.dataTask(with: request, completionHandler: {
//            (data: Data?, response: URLResponse?, error: Error?) -> Void in
//            
//            PhotoStore.requestCounter += 1  // increment from call made
//            
//            if let jsonData = data {
//                if let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
//                    print(jsonString)
//                }
//            } else if let requestError = error {
//                print("Error fetching recent photos: \(requestError)")
//            } else {
//                print("Unexpected error occured.")
//            }
//        })
//        task.resume()   // begin task
//    }
    
//    func fetchRecentPhotos() {
//        let url = FlickrAPI.recentPhotosURL()
//        let request = URLRequest(url: url)
//        
//        print("URL Attempted: \(request)")
//        print("Request number this run: \(PhotoStore.requestCounter)")
//        
//        let task = session.dataTask(with: request, completionHandler: {
//            (data: Data?, response: URLResponse?, error: Error?) -> Void in
//            
//            PhotoStore.requestCounter += 1  // increment from call made
//            
//            
//            if let jsonData = data {
//                // unwraps into a JSON Object if formats correct
//                do {
//                    let jsonObject: AnyObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as AnyObject
//                    print("\(jsonObject)")
//                } catch {
//                    print("Error creating JSON object: \(error)")
//                }
//            } else if let requestError = error {
//                print("Error fetching recent photos: \(requestError)")
//            } else {
//                print("Unexpected error occured.")
//            }
//        })
//        task.resume()   // begin task
//    }
  
    func fetchRecentPhotos(completion: @escaping (PhotoResult) -> Void) {
        let url = FlickrAPI.recentPhotosURL()
        let request = URLRequest(url: url)
        
//        print("URL Attempted: \(request)")
        
        let task = session.dataTask(with: request, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            PhotoStore.requestCounter += 1  // increment from call made
            print("FlickR API Calls made this apps lifetime: \(PhotoStore.requestCounter)")
            
            let result = self.processRecentPhotosRequest(data, error: error)
            completion(result)
        })
        task.resume()   // begin task
    }
    
    func processRecentPhotosRequest(_ data: Data?, error: Error?) -> PhotoResult {
        guard let jsonData = data else { return .failure(error!) }
        
        return FlickrAPI.photosFromJSONData(data: jsonData)
    }
    
    func fetchImageForPhoto(photo: Photo, completion: @escaping (ImageResult) -> Void) {
        let photoURL = photo.remoteURL
        let request = URLRequest(url: photoURL)
        
        let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            let result = self.processImageRequest(data: data, error: error)
            
            // chapter 19 bronze challenge
            if let responseHeaderAndFields = response as? HTTPURLResponse {
                print("Image HTTP Response Status Code: \(responseHeaderAndFields.statusCode) which is in english: \(HTTPURLResponse.localizedString(forStatusCode: responseHeaderAndFields.statusCode))")
                print("Image HTTP Response Header Fields: \(responseHeaderAndFields.allHeaderFields)")
            }
            
            // special use of
            if case let .success(image) = result {
                photo.image = image
            }
            
            completion(result)
        })
        task.resume()
    }
    
    func processImageRequest(data: Data?, error: Error?) -> ImageResult {
        
        guard let imageData = data else { return .failure(error!) }
        guard let image = UIImage.init(data: imageData) else { return .failure(PhotoError.ImageCreationError) }
        
        return .success(image)
    }
}
