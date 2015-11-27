//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Alex Paul on 11/16/15.
//  Copyright © 2015 Alex Paul. All rights reserved.
//

import Foundation
import MapKit

class Photo {
    
    var coordinate: CLLocationCoordinate2D!
    var urlString: String! // url_m String 
    var title: String?
    var id: String!
    var image: UIImage?
    
    init(photoDictionary: [String: AnyObject]) {
        
        urlString = photoDictionary["url_m"] as! String
        title = photoDictionary["title"] as? String
    }
    
    
}