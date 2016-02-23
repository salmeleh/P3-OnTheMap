//
//  PostingViewController.swift
//  OnTheMap
//
//  Created by Stu Almeleh on 2/3/16.
//  Copyright © 2016 Stu Almeleh. All rights reserved.
//

import UIKit
import MapKit

class PostingViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var loadingWheel: UIActivityIndicatorView!
    
    @IBOutlet weak var mapView: MKMapView!
    var searchRequest:MKLocalSearchRequest!
    var search:MKLocalSearch!
    var searchResponse:MKLocalSearchResponse!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    /* Based on student comments, this was added to help with smaller resolution devices */
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1        
        
        locationTextField.delegate = self
        linkTextField.delegate = self
        
        loadingWheel.hidesWhenStopped = true
        initialView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeKeyboardDismissRecognizer()
        self.unsubscribeToKeyboardNotifications()
    }
    
    
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func findButtonPressed(sender: AnyObject) {
        
        
        if locationTextField.text == "" {
            launchAlertController("Please enter a location")
            
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("PostingViewController")
            self.presentViewController(controller, animated: true, completion: nil)
            
        } else {
            mapCode(handlerForMapCode)
            //secondView()
        }
    }
    
    
    func mapCode (completionHandler: ((success: Bool, error: String) -> Void)) {
        loadingWheel.hidden = false
        loadingWheel.startAnimating()

        
        searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = locationTextField.text
        search = MKLocalSearch(request: searchRequest)
        
        search.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            if localSearchResponse == nil{
                completionHandler(success: false, error: "Mapcode Failed")
                //return
                
            } else {
                self.pointAnnotation = MKPointAnnotation()
                self.pointAnnotation.title = self.locationTextField.text
                
                UdacityClient.User.Latitude = localSearchResponse!.boundingRegion.center.latitude
                UdacityClient.User.Longitude = localSearchResponse!.boundingRegion.center.longitude
                self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: UdacityClient.User.Latitude!, longitude: UdacityClient.User.Longitude!)

                let span = MKCoordinateSpanMake(0.08, 0.08)
                let region = MKCoordinateRegionMake(self.pointAnnotation.coordinate, span)
                self.mapView.setRegion(region, animated: true)
                
                self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
                self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
                
                self.loadingWheel.stopAnimating()
                completionHandler(success: true, error: "")
                self.secondView()
            }
        }
    }
    
    
    
    func handlerForMapCode(success: Bool, error: String) -> Void {
        if success {
            //return
        }
        else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.launchAlertController(error)
                self.loadingWheel.stopAnimating()
            })
        }
        
    }

    
    
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        let locationString = locationTextField.text!
        let linkString = linkTextField.text!
        let objectID = UdacityClient.User.ObjectId
        
        loadingWheel.hidden = false
        loadingWheel.startAnimating()
        
        if linkString == "" {
            launchAlertController("Please enter a link")
        } else {
            if objectID != nil {
                ParseClient.sharedInstance().putStudentLocation(objectID!, mapString: locationString, mediaURL: linkString, completionHandler: handlerForSubmit)
            } else {
                ParseClient.sharedInstance().postStudentLocation(locationString, mediaURL: linkString, completionHandler: handlerForSubmit)
            }
        }
        loadingWheel.stopAnimating()
        
    }
    
    
    
    func handlerForSubmit(success: Bool, error: String) -> Void {
        if success {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.launchAlertController(error)
                self.loadingWheel.stopAnimating()
            })
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
        loadingWheel.hidden = true
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
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.locationTextField {
            findButtonPressed(UIButton)
        }
        if textField == self.linkTextField {
            submitButtonPressed(UIButton)
        }
        return true
    }

    
    
    
    
    
    /* shows alert view with error */
    func launchAlertController(error: String) {
        let alertController = UIAlertController(title: "", message: error, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "Dismiss", style: .Default) { (action) in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    
    //MARK: keyboard methods
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
//        if keyboardAdjusted == false {
//            lastKeyboardOffset = getKeyboardHeight(notification) / 2
//            self.view.superview?.frame.origin.y -= lastKeyboardOffset
//            keyboardAdjusted = true
//        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if keyboardAdjusted == true {
            self.view.superview?.frame.origin.y += lastKeyboardOffset
            keyboardAdjusted = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    
    
    
}

