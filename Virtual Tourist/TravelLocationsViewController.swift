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

class TravelLocationsViewController: UIViewController, MKMapViewDelegate {
    
    let MIN_PRESS_DURATION = 0.3
    
    var mapView: MKMapView!
    
    var photoAlbumViewController: PhotoAlbumViewController!
    
    var latitude: Double!
    var longitude: Double!
    var latitudeDelta: Double!
    var longitudeDelta: Double!
    
    var span: MKCoordinateSpan!
    var center: CLLocationCoordinate2D!
    
    var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    var selectedPinCoordinate: CLLocationCoordinate2D!
    var selectedPin: Pin!
    
    var pins = [Pin]()
    var annotations = [MKPointAnnotation]()
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Map View
        self.mapView = MKMapView(frame: (UIScreen.mainScreen().bounds))
        self.view.addSubview(self.mapView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Virtual Tourist"
        
        self.mapView.delegate = self
        
        self.mapView.addAnnotations(self.annotations)
        
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
        
        self.longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "addPinToMapView:")
        self.longPressGestureRecognizer.minimumPressDuration = MIN_PRESS_DURATION
        self.mapView.addGestureRecognizer(self.longPressGestureRecognizer)
    }
    
    // MARK: - Map View Delegate Methods 
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true
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
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        //let coordinate = view.annotation?.coordinate
        
        self.photoAlbumViewController = PhotoAlbumViewController()
        self.photoAlbumViewController.coordinate = self.selectedPinCoordinate
        self.photoAlbumViewController.pin = self.selectedPin
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Ok", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
            self.navigationController?.pushViewController(self.photoAlbumViewController, animated: true)
        }
    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        print("didAddAnnotationViews")
    }
    
    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        print("didFailToLocateUserWithError")
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        self.selectedPinCoordinate = view.annotation?.coordinate
        for pin in self.pins {
            if pin.annotation == view.annotation as! MKPointAnnotation {
                print("coordinate is \(pin.annotation.coordinate)")
                print("pin has \(pin.photos.count) photos")
                self.selectedPin = pin
            }
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
    
    func addPinToMapView(gestureReconizer: UIGestureRecognizer) {
        
        if gestureReconizer.state != UIGestureRecognizerState.Began {return}
        
        let touchPoint = gestureReconizer.locationInView(self.mapView)
        let touchPointCoordinate = self.mapView.convertPoint(touchPoint, toCoordinateFromView: self.mapView)
        
        let coordinate = touchPointCoordinate
        
        print("coordinate is \(coordinate)")
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        self.annotations.append(annotation)
        
        VTFlickrService().fectchPhotosForCoordinate(coordinate) { (success, photos, error) -> Void in
            if success {
                let pin = Pin()
                pin.photos = photos as! [Photo]
                annotation.title = "\(pin.photos.count) photos"
                pin.annotation = annotation
                self.pins.append(pin)
            }else {
                print("Error - \(error)")
            }
        }
        
        // Update Map View 
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.mapView.addAnnotations(self.annotations)
        }
    }

}
