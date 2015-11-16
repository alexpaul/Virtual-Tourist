//
//  PhotoCell.swift
//  Virtual Tourist
//
//  Created by Alex Paul on 11/14/15.
//  Copyright © 2015 Alex Paul. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    var placeholderImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.lightGrayColor()
        
        // Placeholder Image View 
        self.placeholderImageView = UIImageView(frame: frame)
        self.placeholderImageView.image = UIImage(named: "placeholderImage")
        self.placeholderImageView.hidden = true
        self.addSubview(self.placeholderImageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
