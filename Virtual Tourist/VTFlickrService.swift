//
//  VTFlickrService.swift
//  Virtual Tourist
//
//  Created by Alex Paul on 11/16/15.
//  Copyright © 2015 Alex Paul. All rights reserved.
//

import Foundation
import MapKit

class VTFlickrService {
    
    let session = NSURLSession.sharedSession()
    
    func fetchPhotosForCoordinate(coordinate: CLLocationCoordinate2D, completionHandler: (success: Bool, photos: AnyObject!, error: ErrorType!) -> Void){
        
        let method = "flickr.photos.search"
        let methodArguments = [ "method" : method,
                                "api_key" : Constants.FLICKR_KEYS.API_KEY,
                                "format": Constants.FLICKR_KEYS.DATA_FORMAT,
                                "nojsoncallback": Constants.FLICKR_KEYS.NO_JSON_CALLBACK,
                                "extras" : Constants.FLICKR_KEYS.EXTRAS,
                                "radius" : Constants.FLICKR_KEYS.RADIUS,
                                "per_page" : Constants.FLICKR_KEYS.PER_PAGE,
                                "page" : VTSingleton.sharedInstance().currentPageNumber,  // default is 1
                                "lat" : coordinate.latitude as Double,
                                "lon": coordinate.longitude as Double ]
        
        let urlString = Constants.FLICKR_KEYS.BASE_URL + self.escapedParameters(methodArguments as! [String : AnyObject])
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            
            if error != nil {
                print("Error: \(error)")
            }
           
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                if let photosDictionary = parsedResult["photos"] as? NSDictionary {
                    if let photosArray = photosDictionary["photo"] as? [[String : AnyObject]] {
                        var photos = [[String : AnyObject]]()
                        for aPhoto in photosArray {
                            // ONLY add Photo if it has a url_m
                            if let _ = aPhoto["url_m"] as? String {
                                photos.append(aPhoto)
                            }
                        }
                        completionHandler(success: true, photos: photos, error: nil)
                    }
                }
                
            }catch {
                parsedResult = nil
                print("Error - no data \(parsedResult) \(error)")
                completionHandler(success: false, photos: nil, error: error)
            }
            
        }
        task.resume()
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
}
