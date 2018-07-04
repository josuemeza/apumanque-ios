//
//  StoreCategory+CoreDataClass.swift
//  
//
//  Created by Josue Meza Peña on 29-05-18.
//
//

import Foundation
import CoreData
import SwiftyJSON
import SwiftyEssentials

@objc(StoreCategory)
public class StoreCategory: NSManagedObject {
    
    static func all(on context: NSManagedObjectContext) -> [StoreCategory]? {
        let request: NSFetchRequest<StoreCategory> = StoreCategory.fetchRequest()
        return try? context.fetch(request)
    }
    
    static func find(byId id: String, on context: NSManagedObjectContext) -> StoreCategory? {
        let request: NSFetchRequest<StoreCategory> = StoreCategory.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        guard let response = try? context.fetch(request) else { return nil }
        return response.theOnlyOneElement
    }

    func setData(from json: JSON) -> Bool {
        id = String(json["id"].intValue)
        for image in json["images"].array ?? [] {
            if image["name"] == "image_ios" {
                imageUrl = image["image"].string
            }
        }
        name = json["name"].string
        active = json["is_active"].bool ?? false
        code = json["code"].string
        return true
    }
    
}
