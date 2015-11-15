//
//  TravelLocationsViewController.swift
//  Virtual Tourist
//
//  Created by Alex Paul on 11/14/15.
//  Copyright © 2015 Alex Paul. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationsViewController: UIViewController, MKMapViewDelegate {
    
    var mapView: MKMapView!
    var vtActivityView = VTActivityView()
    
    var latitude: Double!
    var longitude: Double!
    var latitudeDelta: Double!
    var longitudeDelta: Double!
    var span: MKCoordinateSpan!
    var center: CLLocationCoordinate2D!
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Map View
        self.mapView = MKMapView(frame: (UIScreen.mainScreen().bounds))
        self.view.addSubview(self.mapView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        latitude = NSUserDefaults.standardUserDefaults().objectForKey(Constants.REGION_KEYS.LATITUDE) as? Double
        longitude = NSUserDefaults.standardUserDefaults().objectForKey(Constants.REGION_KEYS.LONGITUDE) as? Double
        latitudeDelta = NSUserDefaults.standardUserDefaults().objectForKey(Constants.REGION_KEYS.LATITUDE_DELTA) as? Double
        longitudeDelta = NSUserDefaults.standardUserDefaults().objectForKey(Constants.REGION_KEYS.LONGITUDE_DELTA) as? Double
        
        if let _ = latitude {
            span = MKCoordinateSpanMake(latitudeDelta as CLLocationDegrees, longitudeDelta as CLLocationDegrees)
            center = CLLocationCoordinate2DMake(latitude as CLLocationDegrees, longitude as CLLocationDegrees)
            self.mapView.region = MKCoordinateRegion(center: center, span: span)
        }
        
    }
    
    // MARK: - Map View Delegate Methods 
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        print("viewForAnnotation")
        
        let reuseID = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = UIColor.redColor()
            pinView?.rightCalloutAccessoryView = UIButton(type: UIButtonType.DetailDisclosure)
        }else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("calloutAccessoryControlTapped")
    }

    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        print("didAddAnnotationViews")
    }
    
    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        print("didFailToLocateUserWithError")
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("didSelectAnnotationView")
    }
    
    func mapViewWillStartLoadingMap(mapView: MKMapView) {
        print("mapViewWillStartLoadingMap")
        self.vtActivityView.activityIndicatorView.startAnimating()
    }
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        print("mapViewDidFinishLoadingMap")
        self.vtActivityView.activityIndicatorView.stopAnimating()
    }
    
    func mapViewDidFailLoadingMap(mapView: MKMapView, withError error: NSError) {
        print("mapViewDidFailLoadingMap")
        self.vtActivityView.activityIndicatorView.stopAnimating()
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("regionDidChangeAnimated")
        
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

}
