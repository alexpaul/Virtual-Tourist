//
//  Photo.swift
//  Virtual Tourist
//
//  Created by Alex Paul on 11/16/15.
//  Copyright © 2015 Alex Paul. All rights reserved.
//
//  Implementing Core Data
//  1. Import Core Data
//  2. Make the class a subclass of NSManagedObject
//  3. Add @NSManaged if front of each property/attribute
//  4. Include the Core Data init method which inserts the object into the context
//  5. If using a Dictionary to create an instance, write one that takes a dictionary and a context

import Foundation
import MapKit
import CoreData 

class Photo: NSManagedObject { // photo has a coordinate, annotation, image, (is a relationship? )
    
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var imagePath: String? // url_m String
    @NSManaged var title: String?
    @NSManaged var id: String?
    @NSManaged var page: String?
    @NSManaged var pin: Pin? // what type of relationship does a Photo have to a Pin???? (e.g a Movie has an actor (Person)
    
    var image: UIImage? {
        set{
            VTImageService.storeImage(image, withIdentifier: imagePath!)
        }
        get {
            return VTImageService.imageWithIdentifier(imagePath)
        }
    }
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(photoDictionary: [String: AnyObject], context: NSManagedObjectContext) {
        
        let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        imagePath = (photoDictionary["url_m"] as? String)
        title = photoDictionary["title"] as? String
        page = photoDictionary["page"] as? String
        id = photoDictionary["id"] as? String
    }
    
    
}