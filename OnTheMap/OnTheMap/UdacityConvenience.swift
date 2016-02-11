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
    func postSession(username: String, password: String, completionHandler: (result: String?, error: String?) -> Void){
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
                    completionHandler(result: nil, error: "Could not parse session")
                }
            } else {
                completionHandler(result: nil, error: "Could not parse session")
                
            }
        }
    }
    
    //MARK: Function to GET user info
    func getSession(username: String, completionHandler: (result: [String]?, error: String?) -> Void){
        let method = Methods.Users + username
        
        taskForGetMethod(method) {(JSONResult, error) in
            
            guard error == nil else {
                completionHandler(result: nil, error: error)
                return
            }
            
            if let dictionary = JSONResult[JSONResponseKeys.User] as? [String:AnyObject] {
                var result = [String]()
                
                if let firstName = dictionary[JSONResponseKeys.FirstName] as? String{
                    result.append(firstName)
                    if let lastName = dictionary[JSONResponseKeys.LastName] as? String {
                        result.append(lastName)
                        completionHandler(result: result, error: nil)
                    } else {
                        completionHandler(result: nil, error: "Could not parse user data: Last Name")
                    }
                } else {
                    completionHandler(result: nil, error: "Could not parse user data: First Name")
                }
            }
        }

    }
    
    
    
    
    
    
    
}