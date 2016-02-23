//
//  Students.swift
//  OnTheMap
//
//  Created by Stu Almeleh on 2/22/16.
//  Copyright © 2016 Stu Almeleh. All rights reserved.
//

import Foundation

class Students {
    
    var students: [StudentInfo] = [StudentInfo]()
    
    class func sharedInstance() -> Students {

        struct Singleton {
            static var sharedInstance = Students()
        }
        
        return Singleton.sharedInstance
        
    }
    
}