//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Stu Almeleh on 2/9/16.
//  Copyright © 2016 Stu Almeleh. All rights reserved.
//

import Foundation

class ParseClient : NSObject {
    
    //MARK: Properties
    
    var session: NSURLSession
    
    var sessionID : String? = nil
    var userID : Int? = nil
    
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    
    
    //MARK: taskForGetMethod
    func getStudentsLocations(completionHandler: (result: [StudentInfo]?, error: String?) -> Void) {
    let urlString = ParseClient.Constants.baseSecureURL
    let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
    request.addValue(ParseClient.Constants.applicationID, forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue(ParseClient.Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
    
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request) { data, response, error in
        if error != nil {
            return
        }
        print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }

    
    
    //MARK: taskForPostMethod
    func postStudentLocation(mapString: String, mediaURL: String, completionHandler: (success: Bool) -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: "\(ParseClient.Constants.baseSecureURL)")!)
        request.HTTPMethod = "POST"
        request.addValue(ParseClient.Constants.applicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"uniqueKey\": \"\(ParseClient.JSONBodyKeys.UniqueKey)\", \"firstName\": \"\(ParseClient.JSONBodyKeys.FirstName)\", \"lastName\": \"\(ParseClient.JSONBodyKeys.LastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(ParseClient.JSONBodyKeys.Latitude), \"longitude\": \(ParseClient.JSONBodyKeys.Longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
    
    
    
    
    /* Raw JSON -> useable object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void){
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandler(result: parsedResult, error: nil)
    }
    
    
    /* URL -> String */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        var urlVars = [String]()
        for (key, value) in parameters {
            let stringValue = "\(value)"
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            urlVars += [key + "=" + "\(escapedValue!)"]
        }
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    
    
    /* MARK: Shared Instance */
    class func sharedInstance() -> UdacityClient{
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    
    
    
    
    
    
}