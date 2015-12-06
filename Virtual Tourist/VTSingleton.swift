//
//  VTSingleton.swift
//  Virtual Tourist
//
//  Created by Alex Paul on 11/18/15.
//  Copyright © 2015 Alex Paul. All rights reserved.
//

import Foundation

class VTSingleton {
    
    // MARK: Shared Instance
    
    var currentPageNumber: Int = 1 {
        willSet(newPageNumber){
            print("willSet - new page number is \(newPageNumber)")
        }
        didSet(oldPageNumber){
            print("didSet - old number is \(oldPageNumber)")
        }
    }
    
    class func sharedInstance() -> VTSingleton {
        
        struct Singleton {
            static var sharedIntance = VTSingleton()
        }
        return Singleton.sharedIntance
    }
    
    // MARK: - Shared Image Cache
    
    struct Caches {
        static let imageCache = ImageCache()
    }
    
    
    // MARK: - Background Thread
    /*
    1.  To run a process in the background with a delay of 3 seconds
    backgroundThread(3.0, background: {
    // Function here to run in the background
    }
    2.  To run a process in the background then run a completion in the foreground
    backgroundThread(background: {
    // Your function to run in the background
    },
    completion: {
    // A function to run in the foreground when the background thread is complete
    }
    }
    3.  To delay by 3 seconds - not e use of completion parameter without backgrond parameter
    backgroundThread(3.0, completion: {
    // Your delayed function here to run in the foreground
    })
    */
    func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) { () -> Void in
            if background != nil {
                background!()
            }
            let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
            dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
                if completion != nil {
                    completion!()
                }
            })
        }
    }
    
}
