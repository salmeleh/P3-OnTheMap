//
//  ViewController.swift
//  FlickFinder
//
//  Created by Jarrod Parkes on 1/29/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

/* 1 - Define constants */
let BASE_URL: String = "https://api.flickr.com/services/rest/"
let METHOD_NAME = "flickr.photos.search"
let API_KEY = "981c84261b3ba500d2aa1e5dc3bec9a3"
let EXTRAS = "url_m"
let SAFE_SEARCH = "1"
let DATA_FORMAT = "json"
let NO_JSON_CALLBACK = "1"

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var phraseTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!

    @IBAction func searchPhotosByPhraseButtonTouchUp(sender: AnyObject) {
        /* 1 - Hardcode the arguments */
        let methodArguments = [
            "method": METHOD_NAME,
            "api_key": API_KEY,
            "text": "baby asian elephant",
            "safe_search": SAFE_SEARCH,
            "extras": EXTRAS,
            "format": DATA_FORMAT,
            "nojsoncallback": NO_JSON_CALLBACK
        ]
        
        /* 2 - Call the Flickr API with these arguments */
        getImageFromFlickrBySearch(methodArguments)
    }
    
    @IBAction func searchPhotosByLatLonButtonTouchUp(sender: AnyObject) {
        print("Will implement this function in a later step...")
    }
    
    
    
    
    func getImageFromFlickrBySearch(methodArguments: [String: AnyObject]) {
        /* 3 - get the shared NSURLSession to facilitate networking activity */
        let session = NSURLSession.sharedSession()
        
        /* 4 - ceate NSURLRequest using escaped URL */
        let urlString = BASE_URL + escapedParameters(methodArguments)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        
        /* 5 - create NSURLSessionDataTask and completion handler */
        let task = session.dataTaskWithRequest(request) { data, response, downloadError in
            if let error = downloadError {
                print("Could not complete the  request \(error)")
            } else {
                var parsingError: NSError? = nil
                print(data)
            }
        }
        
        /* 6 - resume task*/
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