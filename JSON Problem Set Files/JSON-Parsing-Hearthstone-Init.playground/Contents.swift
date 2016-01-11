//
//  JSON-Parsing-Hearthstone-Solution.playground
//  iOS Networking
//
//  Created by Jarrod Parkes on 09/30/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import Foundation

/* Path for JSON files bundled with the Playground */
var pathForHearthstoneJSON = NSBundle.mainBundle().pathForResource("hearthstone_basic_set", ofType: "json")

/* Raw JSON data (...simliar to the format you might receive from the network) */
var rawHearthstoneJSON = NSData(contentsOfFile: pathForHearthstoneJSON!)

/* Error object */
var parsingHearthstoneError: NSError? = nil

/* Parse the data into usable form */
var parsedHearthstoneJSON = try! NSJSONSerialization.JSONObjectWithData(rawHearthstoneJSON!, options: .AllowFragments) as! NSDictionary

func parseJSONAsDictionary(dictionary: NSDictionary) {
    /* Start playing with JSON here... */
    guard let arrayOfBasicSetCardDictionaries = parsedHearthstoneJSON["Basic"] as? [[String: AnyObject]] else {
        print("Cannot find key 'Basic' in \(parsedHearthstoneJSON)")
        return
    }
    
    for cardDictionary in arrayOfBasicSetCardDictionaries {
        
        let cardType = cardDictionary["type"] as? String
        if cardType == "Minion" {
            let cost = cardDictionary["cost"] as? Int
            if cost == 5 {
                print("cost = 5")
            }
            
            let cardText = cardDictionary["text"] as? String
            if cardText?.rangeOfString("Battlecry") != nil {
                print("contains battlecry")
            }
            
        }
        
        if cardType == "Weapon" {
            let durability = cardDictionary["durability"] as? Int
            if durability == 2 {
                print("durability = 2")
            }
        }
        
        
        
        
    }
}

parseJSONAsDictionary(parsedHearthstoneJSON)
