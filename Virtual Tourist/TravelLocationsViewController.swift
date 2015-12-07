//
//  TravelLocationsViewController.swift
//  Virtual Tourist
//
//  Created by Alex Paul on 11/14/15.
//  Copyright © 2015 Alex Paul. All rights reserved.
//
//  Allows the user to drop pins around the world

import UIKit
import MapKit
import CoreData

class TravelLocationsViewController: UIViewController, MKMapViewDelegate {
    
    let MIN_PRESS_DURATION = 0.3
    
    var mapView: MKMapView!
    
    var photoAlbumViewController: PhotoAlbumViewController!
    
    var latitude: Double!
    var longitude: Double!
    var latitudeDelta: Double!
    var longitudeDelta: Double!
    
    var annotation: MKPointAnnotation!
    
    var span: MKCoordinateSpan!
    var center: CLLocationCoordinate2D!
    
    var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    lazy var editButton = UIBarButtonItem()
    var editPinsBarButton: UIButton!
    
    
    var pins = [Pin]()
    var annotations = [MKPointAnnotation]()
    
    // Shared Object Context 
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Map View
        self.mapView = MKMapView(frame: (UIScreen.mainScreen().bounds))
        self.view.addSubview(self.mapView)
        
        // Edit Pins Button
        let newCollectionButtonSize = CGSize(width: self.view.frame.width, height: 44)
        let newCollectionButtonPoint = CGPoint(x: 0, y: self.view.frame.height - newCollectionButtonSize.height)
        self.editPinsBarButton = UIButton(frame: CGRectMake(newCollectionButtonPoint.x, newCollectionButtonPoint.y, newCollectionButtonSize.width, newCollectionButtonSize.height))
        self.editPinsBarButton.setTitle("Tap Pin To Remove", forState: UIControlState.Normal)
        self.editPinsBarButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.editPinsBarButton.backgroundColor = UIColor.redColor()
        self.editPinsBarButton.hidden = true
        self.view.addSubview(self.editPinsBarButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Virtual Tourist"
        
        self.editButton = UIBarButtonItem(title: Constants.EDIT_OFF, style: UIBarButtonItemStyle.Plain, target: self, action: "toggleEditMode:")
        self.editButton.tintColor = UIColor.blackColor()
        
        self.navigationItem.rightBarButtonItem = self.editButton
        
        self.mapView.delegate = self
        
        // If exists, set Region from NSUserDefaults
        latitude = NSUserDefaults.standardUserDefaults().objectForKey(Constants.REGION_KEYS.LATITUDE) as? Double
        longitude = NSUserDefaults.standardUserDefaults().objectForKey(Constants.REGION_KEYS.LONGITUDE) as? Double
        latitudeDelta = NSUserDefaults.standardUserDefaults().objectForKey(Constants.REGION_KEYS.LATITUDE_DELTA) as? Double
        longitudeDelta = NSUserDefaults.standardUserDefaults().objectForKey(Constants.REGION_KEYS.LONGITUDE_DELTA) as? Double
        
        if let _ = latitude {
            span = MKCoordinateSpanMake(latitudeDelta as CLLocationDegrees, longitudeDelta as CLLocationDegrees)
            center = CLLocationCoordinate2DMake(latitude as CLLocationDegrees, longitude as CLLocationDegrees)
            self.mapView.region = MKCoordinateRegion(center: center, span: span)
        }
        
        self.longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "addPin:")
        self.longPressGestureRecognizer.minimumPressDuration = MIN_PRESS_DURATION
        self.mapView.addGestureRecognizer(self.longPressGestureRecognizer)
        
        // Perform Fetch 
        self.pins = self.performFetch()
        self.addAnnotationsToMapView()

    }
    
    // MARK: - Map View Delegate Methods 
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = false
            pinView?.animatesDrop = true
            pinView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
            if #available(iOS 9.0, *) {
                pinView?.pinTintColor = UIColor.redColor()
            } else {
                // Fallback on earlier version
                pinView?.pinColor = MKPinAnnotationColor.Red
            }
        }else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        print("didAddAnnotationViews")
    }
    
    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        print("didFailToLocateUserWithError")
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {

        if self.editButton.title! == Constants.EDIT_OFF {
            
            self.photoAlbumViewController = PhotoAlbumViewController()
            self.photoAlbumViewController.region = self.mapView.region // Map Region
            self.photoAlbumViewController.sharedContext = self.sharedContext
            
            for pin in self.pins {
                let pinCoordinate = CLLocationCoordinate2DMake(Double(pin.latitude), Double(pin.longitude))
                if (pinCoordinate.latitude == view.annotation!.coordinate.latitude) && (pinCoordinate.longitude == view.annotation!.coordinate.longitude) {
                    self.photoAlbumViewController.pin = pin
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
                        self.navigationController?.pushViewController(self.photoAlbumViewController, animated: true)
                    }
                    break
                }
            }
        }else {
            
            // 1. Delete Pin from Core Data 
            for pin in self.pins {
                let pinCoordinate = CLLocationCoordinate2DMake(Double(pin.latitude), Double(pin.longitude))
                if (pinCoordinate.latitude == view.annotation!.coordinate.latitude) && (pinCoordinate.longitude == view.annotation!.coordinate.longitude) {
                    self.sharedContext.deleteObject(pin)
                    CoreDataStackManager.sharedInstance().saveContext()
                    break
                }
            }
            
            print("PIN DELETED")
            
            // 2. Update Pins
            //self.pins = [Pin]()
            //self.pins = performFetch()
            self.addAnnotationsToMapView()
        
            
            // 3. Remove Images from the Documents Directory
            
            // 3. Update Map View
            
        }

    }
    
    func mapViewWillStartLoadingMap(mapView: MKMapView) {
        print("mapViewWillStartLoadingMap")
    }
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        print("mapViewDidFinishLoadingMap")
    }
    
    func mapViewDidFailLoadingMap(mapView: MKMapView, withError error: NSError) {
        print("mapViewDidFailLoadingMap")
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let region = mapView.region
        latitudeDelta = region.span.latitudeDelta as Double
        longitudeDelta = region.span.longitudeDelta as Double
        latitude = region.center.latitude as Double
        longitude = region.center.longitude as Double
        
        NSUserDefaults.standardUserDefaults().setObject(latitudeDelta, forKey: Constants.REGION_KEYS.LATITUDE_DELTA)
        NSUserDefaults.standardUserDefaults().setObject(longitudeDelta, forKey: Constants.REGION_KEYS.LONGITUDE_DELTA)
        NSUserDefaults.standardUserDefaults().setObject(latitude, forKey: Constants.REGION_KEYS.LATITUDE)
        NSUserDefaults.standardUserDefaults().setObject(longitude, forKey: Constants.REGION_KEYS.LONGITUDE)
    }
    
    // MARK: - Actions 
    
    func addPin(gestureReconizer: UIGestureRecognizer) {
        
        if self.editButton.title == Constants.EDIT_ON {
            // Not able to Add Pins in Edit Mode
            return
        }
        
        if gestureReconizer.state != UIGestureRecognizerState.Began {return}
        
        let touchPoint = gestureReconizer.locationInView(self.mapView)
        let touchPointCoordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        let coordinate = touchPointCoordinate
        
        self.annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        self.annotations.append(annotation)
        
        VTFlickrService().fetchPhotosForCoordinate(coordinate) { (success, photos, error) -> Void in
            
            if error != nil {
                print("Error - \(error)")
                self.downloadAlertMessage(error)
                return
            }
            
            if success {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    // Create a Pin Entity and Add Photo Entities to it - then Save the Context
                    let entity = NSEntityDescription.entityForName("Pin", inManagedObjectContext: self.sharedContext)!
                    let pin = Pin(entity: entity, insertIntoManagedObjectContext: self.sharedContext)
                    pin.latitude = Double(self.annotation.coordinate.latitude)
                    pin.longitude = Double(self.annotation.coordinate.longitude)
                    let photosArray = photos as! [[String : AnyObject]]
                    
                    for result in photosArray {
                        let photo = Photo(photoDictionary: result, context: self.sharedContext)
                        photo.pin = pin
                    }
                    CoreDataStackManager.sharedInstance().saveContext()
                    
                    self.annotation.title = " "//"\(pin.photos.count) photos"
                    self.pins.append(pin)
                })
                
            }else {
                print("Error - \(error)")
            }
        }
        
        // Update Map View 
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.mapView.addAnnotations(self.annotations)
        }
    }
    
    func toggleEditMode(barItem: UIBarButtonItem) {
        
        // Edit Off
        if barItem.title! == Constants.EDIT_ON {
            barItem.title = Constants.EDIT_OFF
            barItem.tintColor = UIColor.blackColor()
            self.editPinsBarButton.hidden = true
         
            // Return Map View Frame to Original Position
            self.mapView.frame.origin.y = 0
        }
        
        // Edit On
        else {
            barItem.title = Constants.EDIT_ON
            barItem.tintColor = UIColor.redColor()
            self.editPinsBarButton.hidden = false
            
            // Move Map View Up for Edit Pins Button
            var newFrame = self.mapView.frame
            newFrame.origin.y -= self.editPinsBarButton.frame.height
            self.mapView.frame = newFrame
        }
    }
    
    // MARK: - Helper Methods 
    
    func performFetch() -> [Pin] {
        
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        do {
            return try self.sharedContext.executeFetchRequest(fetchRequest) as! [Pin]
        }catch let error as NSError {
            print("Error - perform fetch: \(error.localizedDescription)")
            return [Pin]()
        }
    }
    
    func addAnnotationsToMapView() {
        
        if self.pins.count > 0 {
            self.mapView.removeAnnotations(self.annotations)
            self.annotations = [MKPointAnnotation]()
            for pin in self.pins {
                let anAnnotation = MKPointAnnotation()
                anAnnotation.coordinate = CLLocationCoordinate2DMake(Double(pin.latitude), Double(pin.longitude))
                anAnnotation.title = ""
                self.annotations.append(anAnnotation)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.mapView.addAnnotations(self.annotations)
            })
        }
    }
    
    // MARK: - Alerts
    
    func downloadAlertMessage(error: NSError?) {
        let alertController = UIAlertController(title: "Download Error", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(alertAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
