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
        
        // TODO: First try the memory cache
        
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
        
        let path = self.pathForFileName(identifier!)
        
        // TODO: if the image is nil remove from cache
        // TODO: otherwise keep it in memory
        //        if image == nil {
        //            return
        //        }
        
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