//
//  User+CoreDataClass.swift
//  
//
//  Created by Josue Meza Peña on 30-05-18.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(User)
public class User: NSManagedObject {
    
    func setData(from json: JSON) -> Bool {
        id = String(json["id"].intValue)
        firstName = json["first_name"].string
        lastName = json["last_name"].string
        email = json["email"].string
        rut = json["rut"].string
        phone = json["phone_number"].string
        region = json["region"].string
        address = json["address"].string
        birthday = json["birthdate"].string != nil ? Date.parse(stringDate: json["birthdate"].stringValue, format: "yyyy-MM-dd") as NSDate? : nil
        return true
    }

}
