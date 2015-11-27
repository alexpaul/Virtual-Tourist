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
    
    
    static func fetchImageForURL(photoURL: String, completionHandler: (imageData: NSData?, error: NSError?) -> Void) -> NSURLSessionTask {
        
        let request = NSURLRequest(URL: NSURL(string: photoURL)!)
        
        let task = session.dataTaskWithRequest(request) { (data, response, downloadError) -> Void in
            if downloadError != nil {
                completionHandler(imageData: nil, error: downloadError)
            }
            completionHandler(imageData: data, error: nil)
            print("fetched image for url is \(UIImage(data: data!))")
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

    
}
