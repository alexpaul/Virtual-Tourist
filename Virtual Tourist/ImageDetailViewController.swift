//
//  ImageDetailViewController.swift
//  Virtual Tourist
//
//  Created by Alex Paul on 11/29/15.
//  Copyright © 2015 Alex Paul. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {

    
    var imageView: UIImageView!
    var image: UIImage!
    
    override func loadView() {
        super.loadView()
        
        
        // Image View
        self.imageView = UIImageView(frame: CGRectMake(0, 64, self.view.frame.width, self.view.frame.height - 64))
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(self.imageView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.image = self.image
    }

}
