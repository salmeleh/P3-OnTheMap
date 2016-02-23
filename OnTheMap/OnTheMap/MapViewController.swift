//
//  MapViewController.Swift
//  OnTheMap
//
//  Created by Stu Almeleh on 2/9/16.
//  Copyright © 2016 Stu Almeleh. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var annotations = [MKPointAnnotation]()
    @IBOutlet weak var loadingWheel: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        loadingWheel.hidesWhenStopped = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    
    func loadData() {
        loadingWheel.startAnimating()
        
        ParseClient.sharedInstance().getStudentLocations() { (result, error) in
            if result != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    //stop loading animation
                    self.loadingWheel.stopAnimating()
                    
                    
                    Students.sharedInstance().students = result!
                    self.generateAnnotations()
                    self.mapView.addAnnotations(self.annotations)
                }
            } else {
                self.loadingWheel.stopAnimating()
                self.launchAlertController(error!)
            }
        }
    }
    
    
    func generateAnnotations() {
        for dictionary in Students.sharedInstance().students {
            let lat = CLLocationDegrees(dictionary.latitude as Double)
            let long = CLLocationDegrees(dictionary.longitude as Double)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let first = dictionary.firstName as String
            let last = dictionary.lastName as String
            let mediaURL = dictionary.mediaURL as String
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }
    }


    
    
    
    
    
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        loadingWheel.startAnimating()
        UdacityClient.sharedInstance().logout(handlerForLogout)
        self.loadingWheel.stopAnimating()
        
        
        dispatch_async(dispatch_get_main_queue(), {
            //return to login
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
            self.presentViewController(controller, animated: true, completion: nil)
        })
        
    }
    
    
    func handlerForLogout(success: Bool, message: String, error: String){
        if success {
            return
        } else {
            launchAlertController(error)
        }
    }
    
    
    
    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        loadData()
    }
    
    
    
    
    
    
    
    // MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let userLink = view.annotation!.subtitle!
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: userLink!)!)
        }
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