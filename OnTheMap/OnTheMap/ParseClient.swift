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
    func getStudentLocations(completionHandler: (result: [StudentInfo]?, error: String?) -> Void) {
        let urlString = ParseClient.Constants.baseSecureURL
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.addValue(ParseClient.Constants.applicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard (error == nil) else {
                completionHandler(result: nil, error: "Connection Error")
                return
            }
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            let parsedResponse = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! [String:AnyObject]
            if let response = parsedResponse["results"] as? [[String: AnyObject]]{
                let students = StudentInfo.studentsFromDictionary(response)
                completionHandler(result: students, error: "success")
                return
            }
        }
        task.resume()
    }

    
    
    //MARK: taskForPostMethod
    func postStudentLocation(mapString: String, mediaURL: String, completionHandler: (success: Bool, error: String) -> Void) {
        print("taskForPostMethod init")
        print("UniqueKey: " + UdacityClient.User.UniqueKey!)
        
        let request = NSMutableURLRequest(URL: NSURL(string: "\(ParseClient.Constants.baseSecureURL)")!)
        request.HTTPMethod = "POST"
        request.addValue(ParseClient.Constants.applicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //print HTTPBody
        let s = "{\"uniqueKey\": \"\(UdacityClient.User.UniqueKey!)\", \"firstName\": \"\(UdacityClient.User.FirstName!)\", \"lastName\": \"\(UdacityClient.User.LastName!)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(UdacityClient.User.Latitude!), \"longitude\": \(UdacityClient.User.Longitude!)}"
        print("\(s)")
        
        request.HTTPBody = "{\"uniqueKey\": \"\(UdacityClient.User.UniqueKey!)\", \"firstName\": \"\(UdacityClient.User.FirstName!)\", \"lastName\": \"\(UdacityClient.User.LastName!)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(UdacityClient.User.Latitude!), \"longitude\": \(UdacityClient.User.Longitude!)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if error == nil {
                completionHandler(success: false, error: String(error))
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
            print("post succeeded")
            completionHandler(success: true, error: "")
        }
        task.resume()
    }
    
    
    
    //MARK: taskForPutMethod
    func putStudentLocation(objectId: String, mapString: String, mediaURL: String, completionHandler: (success: Bool, error: String) -> Void) {
        print("taskForPutMethod init")

        let urlString = "\(ParseClient.Constants.baseSecureURL)/\(objectId)"
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PUT"
        request.addValue(ParseClient.Constants.applicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = "{\"uniqueKey\": \"\(UdacityClient.User.UniqueKey!)\", \"firstName\": \"\(UdacityClient.User.FirstName)\", \"lastName\": \"\(UdacityClient.User.LastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(UdacityClient.User.Latitude), \"longitude\": \(UdacityClient.User.Longitude)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error == nil {
                completionHandler(success: false, error: String(error))
                return
            } else {
                completionHandler(success: true, error: "")
                print("put succeeded")
            }
        }
        task.resume()
    }

    
    
    
    
    
    /* Raw JSON -> useable object */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: String?) -> Void){
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        } catch {
            completionHandler(result: nil, error: "Could not parse the data as JSON")
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
    class func sharedInstance() -> ParseClient{
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
    
    
    
    
    
    
    
}