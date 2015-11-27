//
//  PhotoCell.swift
//  Virtual Tourist
//
//  Created by Alex Paul on 11/14/15.
//  Copyright © 2015 Alex Paul. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var activityView: VTActivityView!
    
    // The property uses a property observer. Any time its
    // value is set it canceles the previous NSURLSessionTask
    var taskToCancelifCellIsReused: NSURLSessionTask? {
        didSet {
            if let taskToCancel = oldValue {
                taskToCancel.cancel()
            }
        }
    }
    
    // TODO: Create a Placeholder Image 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.lightGrayColor()
        
        // Image View
        self.imageView = UIImageView(frame: frame)
        self.addSubview(self.imageView)
        
        // Placeholder Image View 
        
        // Activity View 
        self.activityView = VTActivityView(frame: frame)
        self.addSubview(self.activityView)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
