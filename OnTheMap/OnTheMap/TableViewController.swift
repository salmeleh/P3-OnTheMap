//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Stu Almeleh on 2/3/16.
//  Copyright © 2016 Stu Almeleh. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    var studentInfo: [StudentInfo] = []
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var loadingWheel: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingWheel.hidesWhenStopped = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    
    func loadData() {
        //start loading animation
        loadingWheel.startAnimating()
        
        ParseClient.sharedInstance().getStudentLocations() { (result, error) in
            if result != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.loadingWheel.stopAnimating()
                    
                    self.studentInfo = result!
                    self.tableView.reloadData()
                }
            } else {
                //stop loading animation
                self.loadingWheel.stopAnimating()

                
                self.launchAlertController(error!)
            }
        }
    }
    
    
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        let studentData = studentInfo[indexPath.row]
        let studentURL = studentData.mediaURL
        UIApplication.sharedApplication().openURL(NSURL(string: "\(studentURL)")!)        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier = "studentInfoCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        let studentData = studentInfo[indexPath.row]

        cell.textLabel!.text = studentData.firstName + " " + studentData.lastName
        cell.detailTextLabel!.text = studentData.mediaURL
        
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return studentInfo.count
    }
    
    


    @IBAction func logoutButtonPressed(sender: AnyObject) {
        loadingWheel.startAnimating()
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            self.loadingWheel.stopAnimating()
            
            if error != nil { // Handle error...
            return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        
        
        task.resume()
        
        dispatch_async(dispatch_get_main_queue(), {
            //creturn to login
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
        
    }
    

    
    @IBAction func refreshButtonPressed(sender: AnyObject) {
        loadData()
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




