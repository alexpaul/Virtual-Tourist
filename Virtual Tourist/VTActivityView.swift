//
//  VTActivityView.swift
//  Virtual Tourist
//
//  Created by Alex Paul on 11/14/15.
//  Copyright © 2015 Alex Paul. All rights reserved.
//

import UIKit

class VTActivityView: UIView {

    var windowFrame = CGSizeMake(UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
    var activityIndicatorView: UIActivityIndicatorView!
    var containerView: UIView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        let activityViewSize = CGSizeMake(100, 100)
        self.frame = CGRectMake(0, 0, windowFrame.width, windowFrame.height)
        
        self.activityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(windowFrame.width / 2 - (activityViewSize.width / 2), windowFrame.height / 2 - (activityViewSize.height / 2), activityViewSize.width, activityViewSize.height))
        self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        self.activityIndicatorView.color = UIColor.whiteColor()
        
        self.addSubview(self.activityIndicatorView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
