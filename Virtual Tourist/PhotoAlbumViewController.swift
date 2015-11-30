//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Alex Paul on 11/14/15.
//  Copyright © 2015 Alex Paul. All rights reserved.
//
//  Allows the users to download and edit an album for a location

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    var newCollectionButton: UIButton!
    var noImagesLabel: UILabel!
    var bottomBarContainerView: UIView!
    var layout: UICollectionViewFlowLayout!
    var coordinate: CLLocationCoordinate2D?
    var pin: Pin!
    var mapView: MKMapView!
    var region: MKCoordinateRegion!
    var annotation: MKPointAnnotation!
    
    // Contorllers 
    var imageDetailViewController: ImageDetailViewController!
    
    // MARK: - View Life Cycle
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Map View
        let mapViewSize = CGSize(width: self.view.frame.width, height: 120)
        let mapViewPoint = CGPoint(x: 0, y: Constants.statusBarHeight + Constants.navigationBarHeight)
        self.mapView = MKMapView(frame: CGRectMake(mapViewPoint.x, mapViewPoint.y, mapViewSize.width, mapViewSize.height))
        self.view.addSubview(self.mapView)

        // Photos Collection View
        self.layout = UICollectionViewFlowLayout()
        let itemWidth: CGFloat = (self.view.frame.width / 3) - 4
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumLineSpacing = 4
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        
        let yPointForCollectionView = Constants.statusBarHeight + Constants.navigationBarHeight + self.mapView.frame.height
        let heightForCollectionView = self.view.frame.height - (Constants.statusBarHeight + Constants.navigationBarHeight + mapView.frame.height + Constants.tabBarHeight)
        self.collectionView = UICollectionView(frame: CGRectMake(0, yPointForCollectionView, self.view.frame.width, heightForCollectionView), collectionViewLayout: layout)
        self.collectionView.backgroundColor = UIColor.whiteColor()
        self.collectionView.registerClass(PhotoCell.classForCoder(), forCellWithReuseIdentifier: "PhotoCell")
        self.view.addSubview(self.collectionView)
        
        // No Images Label
        let noImagesLabelSize = CGSize(width: 200, height: 30)
        let noImagesLabelPoint = CGPoint(x: self.collectionView.center.x - (noImagesLabelSize.width / 2), y: self.collectionView.frame.height / 2 - (noImagesLabelSize.height / 2))
        self.noImagesLabel = UILabel(frame: CGRectMake(noImagesLabelPoint.x, noImagesLabelPoint.y, noImagesLabelSize.width, noImagesLabelSize.height))
        self.noImagesLabel.text = "This Pin has no Images"
        self.noImagesLabel.textAlignment = NSTextAlignment.Center
        self.noImagesLabel.hidden = true
        self.collectionView.addSubview(self.noImagesLabel)
        
        let bottomBarContainerViewSize = CGSize(width: self.view.frame.width, height: Constants.tabBarHeight)
        let bottomBarContainerViewPoint = CGPoint(x: 0, y: self.view.frame.height - Constants.tabBarHeight)
        self.bottomBarContainerView = UIView(frame: CGRectMake(bottomBarContainerViewPoint.x, bottomBarContainerViewPoint.y, bottomBarContainerViewSize.width, bottomBarContainerViewSize.height))
        self.bottomBarContainerView.backgroundColor = Constants.COLOR_KEYS.BAR_TINT_COLOR
        self.view.addSubview(self.bottomBarContainerView)
        
        // New Collection Button
        let newCollectionButtonSize = CGSize(width: 150, height: 44)
        let newCollectionButtonPoint = CGPoint(x: bottomBarContainerView.center.x - (newCollectionButtonSize.width / 2), y: bottomBarContainerView.center.y - (newCollectionButtonSize.height / 2))
        self.newCollectionButton = UIButton(frame: CGRectMake(newCollectionButtonPoint.x, newCollectionButtonPoint.y, newCollectionButtonSize.width, newCollectionButtonSize.height))
        self.newCollectionButton.setTitle("New Collection", forState: UIControlState.Normal)
        self.newCollectionButton.setTitleColor(Constants.COLOR_KEYS.BUTTON_TITLE_COLOR, forState: UIControlState.Normal)
        self.newCollectionButton.addTarget(self, action: "newCollectionButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.newCollectionButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.pin.photos.count == 0 {self.noImagesLabel.hidden = false}
        
        // Setup the Map View
        self.mapView.region = self.region
        self.mapView.addAnnotation(self.annotation)
        self.mapView.userInteractionEnabled = false
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    // MARK: - Collection View Datasource Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pin.photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let photoCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        let photo = self.pin.photos[indexPath.row]
        
        self.configureCell(photoCell, photo: photo, indexPath: indexPath)
        
        return photoCell
    }
    
    func configureCell(photoCell: PhotoCell, photo: Photo, indexPath: NSIndexPath) {
        
        // TODO: Set Cell's Placeholder Image 
        
        if photo.image != nil {
            photoCell.imageView.image = photo.image
        }else {
            photoCell.activityView.activityIndicatorView.startAnimating()
            let task = VTImageService.fetchImageForURL(photo.urlString!, completionHandler: { (imageData, downloadError) -> Void in
                if let errorFound = downloadError {
                    print("Error - \(errorFound.localizedDescription)")
                }
                if let data = imageData {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        photo.image = UIImage(data: data)
                        photoCell.imageView.image = photo.image
                        photoCell.activityView.activityIndicatorView.stopAnimating()
                    })
                }
            })
            photoCell.taskToCancelifCellIsReused = task
        }
    }
    
    // MARK: - Collection View Delegate Methods 
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        let photo = self.pin.photos[indexPath.row]
    
        self.imageDetailViewController = ImageDetailViewController()
        self.imageDetailViewController.image = photo.image
        
        self.navigationController?.pushViewController(self.imageDetailViewController, animated: false)
    }
    
    // MARK: - Actions
    
    func newCollectionButtonPressed() {
        print("newCollectionButtonPressed")
        
        // Increment Page Number
        VTSingleton.sharedInstance().currentPageNumber++
        
        // Do a New Page Search
        VTFlickrService().fetchPhotosForCoordinate(self.coordinate!) { (success, photos, error) -> Void in
            if error != nil {
                print("Error - \(error)")
            }
            if success {
                
                if let newPhotos = photos {
                    self.pin = Pin()
                    self.pin.photos = newPhotos as! [Photo]
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.collectionView.reloadData()
                    })
                }
            }
        }
    }
    
    // MARK: - Collection View Flow Layout Delegate Methods
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        print("minimumInteritemSpacingForSectionAtIndex")
        return 1
    }


}
