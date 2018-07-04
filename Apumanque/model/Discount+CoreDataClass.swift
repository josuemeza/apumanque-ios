//
//  Discount+CoreDataClass.swift
//  
//
//  Created by Josue Meza Peña on 31-05-18.
//
//

import Foundation
import CoreData
import SwiftyJSON
import SwiftyEssentials

@objc(Discount)
public class Discount: NSManagedObject {
    
    static func all(on context: NSManagedObjectContext) -> [Discount]? {
        let request: NSFetchRequest<Discount> = Discount.fetchRequest()
        return try? context.fetch(request)
    }

    func setData(from json: JSON) -> Bool {
        guard let context = managedObjectContext else { return false }
        id = String(json["id"].intValue)
        title = json["title"].string
        valuePercent = json["value_percent"].string
        detail = json["description"].string
        code = json["code"].string
        resume = json["resume"].string
        conditions = json["conditions"].string
        active = json["is_active"].bool ?? false
        imageUrl = json["images"][0]["image"].string
        startDate = json["start_date"].string != nil ? Date.parse(stringDate: json["start_date"].stringValue, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") as NSDate? : nil
        expireDate = json["expire_date"].string != nil ? Date.parse(stringDate: json["expire_date"].stringValue, format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ") as NSDate? : nil
        store = Store.find(byId: json["id_store"]["id"].intValue, on: context)
        return true
    }
    
}
