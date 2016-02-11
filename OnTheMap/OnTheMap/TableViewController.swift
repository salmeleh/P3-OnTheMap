//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Stu Almeleh on 2/3/16.
//  Copyright © 2016 Stu Almeleh. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    
    var studentInfo = [StudentInfo]()
    
    private struct studentCellData {
        var name: String?
        var URL: String?
    }
    
    private var studentCellDataArray = [studentCellData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("studentInfo", forIndexPath: indexPath) as UITableViewCell
        
        //Configure the cell
        let info = studentCellDataArray[indexPath.row]
        cell.textLabel?.text = info.name
        cell.detailTextLabel?.text = info.URL
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studentCellDataArray.count
    }
    
    


    @IBAction func logoutButtonPressed(sender: AnyObject) {
        
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
    
    
    
}

