//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Stu Almeleh on 2/8/16.
//  Copyright © 2016 Stu Almeleh. All rights reserved.
//

import Foundation

class UdacityClient : NSObject {

    var session: NSURLSession
    
    var sessionID: String? = nil
    var userID: Int? = nil
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }

    
    
    //taskForPostMethod//
    func postASession(email: String, password: String, completionHandler: (success: Bool, error: String) -> Void) -> NSURLSessionDataTask {
        
        let urlString = Constants.UdacityBaseURL + UdacityClient.Methods.Session
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = session.dataTaskWithRequest(request){ (data, response, error) in
            
            guard (error == nil) else {
                completionHandler(success: false, error: "Connection Error")
                return
            }
            
            UdacityClient.parseJSONForPostMethod(data!, completionHandler: completionHandler)
        }
        
        task.resume()
        return task
    }
    
    
    
    //getUserData//
    func getUserData(key: String) {
        
        let urlString = UdacityClient.Constants.UdacityBaseURL + UdacityClient.Methods.Users + key
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard (error == nil) else {
                print("Connection Error")
                return
            }
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            var parsedResponse = try! NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments) as! [String:AnyObject]
            
            guard let accountDictionary = parsedResponse["user"] as? NSDictionary else {
                print("Cannot find keys 'account' in \(parsedResponse)")
                return
            }
            let firstName = accountDictionary ["first_name"] as? String
            UdacityClient.User.FirstName = firstName
            let lastName = accountDictionary ["last_name"] as? String
            UdacityClient.User.LastName = lastName
        }
        task.resume()
    }
    
    
    func logout(completionHandler: ((success: Bool, message: String, error: String) -> Void)) {
        
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
            if error != nil && data != nil {
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5))
            print(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        
        
        task.resume()

        
        
    }
    
    
    
    /* Raw JSON -> useable object */
    class func parseJSONForPostMethod(data: NSData, completionHandler: (success: Bool, error: String) -> Void){
        let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
        var parsedResponse = try! NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments) as! [String:AnyObject]

        let error = parsedResponse["error"] as? String
        if parsedResponse["error"] != nil {
            completionHandler(success: false, error: error!)
            return
        }
        
        guard let accountDictionary = parsedResponse["account"] as? NSDictionary else {
            print("Cannot find keys 'account' in \(parsedResponse)")
            return
        }
        
        
        
        let registered = accountDictionary ["registered"] as? Int
        let user = accountDictionary ["key"] as? String
        
        if registered != 1 {
            print("Account not registered")
        }
        if registered == 1 {
            completionHandler(success: true, error: "")
            UdacityClient.User.UniqueKey = user
            UdacityClient.sharedInstance().getUserData(user!)
        }

        
        
    }
    
    /* MARK -- Shared Instance */
    class func sharedInstance() -> UdacityClient{
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }




}