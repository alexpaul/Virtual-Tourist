//
//  ImageCache.swift
//  Virtual Tourist
//
//  Created by Alex Paul on 12/5/15.
//  Copyright © 2015 Alex Paul. All rights reserved.
//

import Foundation
import UIKit

class ImageCache {
    
    
    private var inMemoryCache = NSCache()
    
    // Retrieving an Image
    func imageWithIdentifier(identifier: String?) -> UIImage? {
        
        if identifier == nil || identifier == "" {
            return nil
        }
        
        let path = self.pathForFileName(identifier!)
        print("\nimageWithIdentifier - retrieving from path: \(path)\n")
        
        // First try the memory cache
        if let image = inMemoryCache.objectForKey(path) {
            return image as? UIImage
        }
        
        // Next try the Documents Directory
        if let data = NSData(contentsOfFile: path) {
            let image = UIImage(data: data)
            print("\n\nimageWithIdentifier - retrieved image: \(image)\n")
            return image
        }else {
            print("\nimageWithIdentifier - nil")
        }
        
        return nil
    }
    
    // Storing an Image
    func storeImage(image: UIImage?, withIdentifier identifier: String?) {
        
        if identifier == nil || identifier == "" {
            return
        }
        
        let path = self.pathForFileName(identifier!)
        
         // If the image is nil remove from cache
        if image == nil {
            
            inMemoryCache.removeObjectForKey(path)
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            }catch {
                print("Error removing image from cache")
            }
            return
        }
        
        // Otherwise keep the image in memory 
        inMemoryCache.setObject(image!, forKey: path)
        
        // Save in Documents Directory
        let data = UIImagePNGRepresentation(image!)!
        let success = data.writeToFile(path, atomically: true)
        if success {
            print("storeImage - image successfully saved at path: \(path)")
        }else {
            print("storeImage - Error saving image at path: \(path)\n")
        }
    }
    
    // Delete an Image 
    func deleteImage(withIdentifier identifier: String?) {
        
        let path = self.pathForFileName(identifier!)
        
        let fileManager = NSFileManager.defaultManager()
        do{
            try fileManager.removeItemAtPath(path)
            print("successfully deleted image at path: \(path)")
        }catch let error as NSError {
            print("Error - Deleting Image: \(error)")
        }
        
    }
    
    func pathForFileName(identifier: String) -> String {
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(identifier)
        return fullURL.path!
    }

}