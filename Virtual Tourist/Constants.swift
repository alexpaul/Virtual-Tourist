//
//  Constants.swift
//  Virtual Tourist
//
//  Created by Alex Paul on 11/15/15.
//  Copyright © 2015 Alex Paul. All rights reserved.
//

import Foundation
import UIKit

class Constants {
    
    var pinAnnotionsArrayURL: NSURL {
        let filename = "pinAnnotationsArray"
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        return documentsDirectoryURL.URLByAppendingPathComponent(filename)
    }
    
    static let navigationBarHeight: CGFloat = 44
    static let statusBarHeight: CGFloat = 20
    static let tabBarHeight: CGFloat = 49
    
    struct REGION_KEYS {
        static let LATITUDE_DELTA = "latitude delta"
        static let LONGITUDE_DELTA = "longitude delta"
        static let LATITUDE = "latitude"
        static let LONGITUDE = "longitude"
    }
    
    struct COLOR_KEYS {
        static let BAR_TINT_COLOR = UIColor(red: 0.969, green: 0.969, blue: 0.976, alpha: 1.0)
        static let BUTTON_TITLE_COLOR = UIColor(red: 0.118, green: 0.537, blue: 0.996, alpha: 1.0) 
    }
    
}
