//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Stu Almeleh on 2/3/16.
//  Copyright © 2016 Stu Almeleh. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
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
                    Students.sharedInstance().students = result!
                    
                    self.loadingWheel.stopAnimating()
                    self.tableView.reloadData()
                }
            } else {
                //stop loading animation
                self.loadingWheel.stopAnimating()

                
                self.launchAlertController(error!)
            }
        }
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let studentData = Students.sharedInstance().students[indexPath.row]
        let studentURL = studentData.mediaURL
        UIApplication.sharedApplication().openURL(NSURL(string: "\(studentURL)")!)        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier = "studentInfoCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        let studentData = Students.sharedInstance().students[indexPath.row]

        cell.textLabel!.text = studentData.firstName + " " + studentData.lastName
        cell.detailTextLabel!.text = studentData.mediaURL
        
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return Students.sharedInstance().students.count
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




