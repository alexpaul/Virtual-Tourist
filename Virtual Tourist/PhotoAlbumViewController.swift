//
//  PhotoAlbumViewController.swift
//  Virtual Tourist
//
//  Created by Alex Paul on 11/14/15.
//  Copyright © 2015 Alex Paul. All rights reserved.
//

import UIKit

class PhotoAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var photos = [String]()
    var collectionView: UICollectionView!
    var newCollectionButton: UIButton!
    
    override func loadView() {
        super.loadView()
        
        // Photos Collection View
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 30, height: 30)
        layout.minimumLineSpacing = 4
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) // default is 0
        
        self.collectionView = UICollectionView(frame: CGRectMake(0, 0, 0, 0), collectionViewLayout: layout)
        self.collectionView.registerClass(PhotoCell.classForCoder(), forCellWithReuseIdentifier: "PhotoCell")
        self.view.addSubview(self.collectionView)
        
        // New Collection Button 
        self.newCollectionButton = UIButton(frame: CGRectMake(0, 0, 0, 0))
        self.newCollectionButton.setTitle("New Collection", forState: UIControlState.Normal)
        self.newCollectionButton.enabled = false
        self.newCollectionButton.addTarget(self, action: "newCollectionButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.newCollectionButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Collection View Datasource Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        
        return photoCell
    }
    
    // MARK: - Collection View Delegate Methods
    
    // MARK: - Helper Methods 
    
    func newCollectionButtonPressed() {
        print("newCollectionButtonPressed")
    }


}
