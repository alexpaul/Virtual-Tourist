//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Alex Paul on 11/16/15.
//  Copyright © 2015 Alex Paul. All rights reserved.
//

import Foundation
import MapKit
import CoreData 

class Photo {
    
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    var urlString: String! // url_m String 
    var title: String?
    var id: String!
    var image: UIImage?
    var page: String? 
    
    init(photoDictionary: [String: AnyObject]) {
        
        urlString = photoDictionary["url_m"] as! String
        title = photoDictionary["title"] as? String
        page = photoDictionary["page"] as? String
        id = photoDictionary["id"] as? String
    }
    
    
}