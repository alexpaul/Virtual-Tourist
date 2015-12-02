//
//  VTImageService.swift
//  Virtual Tourist
//
//  Created by Alex Paul on 11/18/15.
//  Copyright © 2015 Alex Paul. All rights reserved.
//

import Foundation
import UIKit

class VTImageService {
    
    static var image: UIImage!
    static let IMAGESIZE = 80
    static let session = NSURLSession.sharedSession()
    private var inMemoryCache = NSCache()
    
    
    static func fetchImageForURL(photoURL: String, completionHandler: (imageData: NSData?, error: NSError?) -> Void) -> NSURLSessionTask {
        
        let request = NSURLRequest(URL: NSURL(string: photoURL)!)
        
        let task = session.dataTaskWithRequest(request) { (data, response, downloadError) -> Void in
            if downloadError != nil {
                completionHandler(imageData: nil, error: downloadError)
            }
            completionHandler(imageData: data, error: nil)
        }
        task.resume()
        
        return task
    }
    
    static func resizeImage(image: UIImage, newSize: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        UIGraphicsBeginImageContext(rect.size)
        image.drawInRect(rect)
        let tempImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageData = UIImagePNGRepresentation(tempImage)
        let newImage = UIImage(data: imageData!)
        
        return newImage!
    }
    
    // Retrieving an Image
    static func imageWithIdentifier(identifier: String?) -> UIImage? {
        
        if identifier == nil || identifier != "" {
            return nil
        }
        
        let path = VTSingleton.sharedInstance().pathForFileName(identifier!)
        
        // TODO: First try the memory cache
        
        // Next try the Documents Directory 
        if let data = NSData(contentsOfFile: path) {
            return UIImage(data: data)
        }
        
        return nil
    }

    // Storing an Image 
    static func storeImage(image: UIImage?, withIdentifier identifier: String?) {
        
        let path = VTSingleton.sharedInstance().pathForFileName(identifier!)
        
        // TODO: if the image is nil remove from cache 
        // TODO: otherwise keep it in memory
//        if image == nil {
//            return
//        }
        
        // Save in Documents Directory
        let data = UIImagePNGRepresentation(image!)!
        data.writeToFile(path, atomically: true)
        
        print("image stored in path: \(path)")
    }
    
}
