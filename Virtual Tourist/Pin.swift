//
//  Pin.swift
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

class Pin: NSManagedObject {
    
    @NSManaged var photos: [Photo] // Relationship between Pin and Photo
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
//    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
//        
//        let entity = NSEntityDescription.entityForName("Pin", inManagedObjectContext: context)!
//        
//        super.init(entity: entity, insertIntoManagedObjectContext: context)
//        
//        //
//    }
    
}