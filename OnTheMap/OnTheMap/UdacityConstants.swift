//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Stu Almeleh on 2/8/16.
//  Copyright © 2016 Stu Almeleh. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    //MARK: Constants
    struct Constants{
        static let UdacityBaseURL: String = "https://www.udacity.com/api/"
    }
    
    //MARK: Methods
    struct Methods{
        static let Session = "session"
        static let Users = "users/"
    }
    
    //MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Username = "username"
        static let Password = "password"
        static let Udacity = "udacity"
    }
    
    //MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        //MARK: Account
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        
        //MARK: Session
        static let Session = "session"
        static let ID = "id"
        static let Expiration = "expiration"
        
        //MARK: User Data
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }

    struct User {
        static var Email : String?
        static var Password : String?
        static var UniqueKey : String?
        
        static var LastName : String?
        static var FirstName : String?
        
        static var MediaURL : String?
        static var MapString : String?
        static var Latitude : Double?
        static var Longitude : Double?
        static var UpdatedAt : String?
        static var ObjectId : String?
        static var CreatedAt : String?
    }

    
    
}
