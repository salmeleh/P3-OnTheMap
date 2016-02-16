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

    /* GET */
    func taskForGetMethod(method: String, completionHandler:(result: AnyObject!, error: String?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = Constants.UdacityBaseURL + method
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        
        let task = session.dataTaskWithRequest(request) {(data, response, error) in
            
            guard (error == nil) else {
                completionHandler(result: nil, error: "Connection Error")
                return
            }
            guard let data = data else {
                print("No data was returned by the request")
                return
            }
            
//            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
//                if let response = response as? NSHTTPURLResponse {
//                    let userInfo = [NSLocalizedDescriptionKey: "Request returned an invalid respons. Status code: \(response.statusCode)!"]
//                    completionHandler(result: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
//                } else if let response = response {
//                    let userInfo = [NSLocalizedDescriptionKey: "Request returned an invalid response. Response: \(response)!"]
//                    completionHandler(result: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
//                } else {
//                    let userInfo = [NSLocalizedDescriptionKey: "Request returned an invalid response"]
//                    completionHandler(result: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
//                }
//                return
//            }
//            
//            guard let data = data else {
//                let userInfo = [NSLocalizedDescriptionKey: "No data was returned by the request"]
//                completionHandler(result: nil, error: NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
//                return
//            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            UdacityClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
        }
        
        task.resume()
        return task
    
    }
    
    
    /* POST */
    func taskForPostMethod(method: String, jsonBody: [String: AnyObject], completionHandler: (result: AnyObject!, error: String?) -> Void) -> NSURLSessionDataTask {
        
        let urlString = Constants.UdacityBaseURL + method
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do{
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        let task = session.dataTaskWithRequest(request){ (data, response, error) in
            
            guard (error == nil) else {
                completionHandler(result: nil, error: "Connection Error")
                return
            }
            guard let data = data else {
                print("No data was returned by the request")
                return
            }
            
//            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
//                if let response = response as? NSHTTPURLResponse {
//                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response. Status code: \(response.statusCode)!"]
//                    completionHandler(result: nil, error: NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
//                } else if let response = response {
//                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response. Response: \(response)!"]
//                    completionHandler(result: nil, error: NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
//                } else {
//                    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response"]
//                    completionHandler(result: nil, error: NSError(domain: "taskForPostMethod'", code: 1, userInfo: userInfo))
//                }
//                return
//            }
//            
//            guard let data = data else {
//                let userInfo = [NSLocalizedDescriptionKey: "No data was returned by the request"]
//                completionHandler(result: nil, error: NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
//                return
//            }

            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            UdacityClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
        }
        
        task.resume()
        return task
    }
    
    
    //func logout(completionHandler: ((success: Bool, message: String, error: NSError?) -> Void)) {
    //
    //}
    
    
    
    /* Raw JSON -> useable object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: String?) -> Void){
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        } catch {
            completionHandler(result: nil, error: "Could not parse the data as JSON: '\(data)'")
        }
        completionHandler(result: parsedResult, error: nil)
    }
    
    /* MARK -- Shared Instance */
    class func sharedInstance() -> UdacityClient{
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }




}