//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Stu Almeleh on 2/8/16.
//  Copyright © 2016 Stu Almeleh. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    //MARK: Function to POST new session
    func postSession(username: String, password: String, completionHandler: (result: String?, error: NSError?) -> Void){
        let method = Methods.Session
        let jsonBody = [
            JSONBodyKeys.Udacity : [
                JSONBodyKeys.Username : username,
                JSONBodyKeys.Password : password
            ],
        ]
        
        taskForPostMethod(method, jsonBody: jsonBody) { (JSONResult, error) in
            guard error == nil else {
                completionHandler(result: nil, error: error)
                return
            }
            
            if let dictionary = JSONResult! [JSONResponseKeys.Account] as? [String : AnyObject] {
                if let result = dictionary[JSONResponseKeys.Key] as? String {
                    completionHandler(result: result, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "POST Session parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse session"]))
                }
            } else {
                completionHandler(result: nil, error: NSError(domain: "POST Session parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse session"]))
                
            }
        }
    }
    
    
    func deleteSession() {
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
    }
    
    
    
}