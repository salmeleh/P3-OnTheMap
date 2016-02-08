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
    
}