//
//  PostingViewController.swift
//  OnTheMap
//
//  Created by Stu Almeleh on 2/3/16.
//  Copyright © 2016 Stu Almeleh. All rights reserved.
//

import UIKit
import MapKit

class PostingViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    
    @IBOutlet weak var linkTextField: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    var searchRequest:MKLocalSearchRequest!
    var search:MKLocalSearch!
    var searchResponse:MKLocalSearchResponse!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initialView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func findButtonPressed(sender: AnyObject) {
        secondView()
        
        if locationTextField.text == "" {
            launchAlertController("Please enter a location")
        } else {
            mapCode(handlerForMapCode)
        }
    }
    
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
    
    
    }
   
    
    
    func mapCode (completionHandler: ((success: Bool, message: String, error: NSError?) -> Void)) {
        searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = locationTextField.text
        search = MKLocalSearch(request: searchRequest)
        
        search.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            if localSearchResponse == nil{
                completionHandler(success: false, message: "Mapcode Failed", error: nil)
                return
            } else {
                self.pointAnnotation = MKPointAnnotation()
                self.pointAnnotation.title = self.locationTextField.text
                
                UdacityClient.User.Latitude = localSearchResponse!.boundingRegion.center.latitude
                UdacityClient.User.Longitude = localSearchResponse!.boundingRegion.center.longitude
                self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: UdacityClient.User.Latitude!, longitude: UdacityClient.User.Longitude!)


                self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
                self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
                
                completionHandler(success: true, message: "Successful", error: nil)
            }
        }
    }
    
    
    
    func handlerForMapCode(success: Bool, message: String, error: NSError?) -> Void {
        if success {
            return
        }
        else {
            launchAlertController(message)
        }
        
    }
    
    

    func initialView() {
        labelOne.hidden = false
        labelTwo.hidden = false
        labelThree.hidden = false
        findButton.hidden = false
        locationTextField.hidden = false
        submitButton.hidden = true
        linkTextField.hidden = true
    }

    func secondView() {
        labelOne.hidden = true
        labelTwo.hidden = true
        labelThree.hidden = true
        findButton.hidden = true
        locationTextField.hidden = true
        submitButton.hidden = false
        linkTextField.hidden = false
    }
    
    func thirdView() {
        
    }
    
    
    
    /* shows alert view with error */
    func launchAlertController(error: String) {
        let alertController = UIAlertController(title: "", message: error, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "Dismiss", style: .Default) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    
    
}

