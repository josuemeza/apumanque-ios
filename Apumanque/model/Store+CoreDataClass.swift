//
//  Store+CoreDataClass.swift
//  
//
//  Created by Josue Meza Peña on 29-05-18.
//
//

import Foundation
import CoreData
import SwiftyJSON
import SwiftyEssentials

@objc(Store)
public class Store: NSManagedObject {
    
    static func all(on context: NSManagedObjectContext) -> [Store]? {
        let request: NSFetchRequest<Store> = Store.fetchRequest()
        return try? context.fetch(request)
    }
    
    static func find(byId id: Int, on context: NSManagedObjectContext) -> Store? {
        let request: NSFetchRequest<Store> = Store.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", String(id))
        guard let response = try? context.fetch(request) else { return nil }
        return response.theOnlyOneElement
    }
    
    func setData(from json: JSON) -> Bool {
        guard let context = managedObjectContext else { return false }
        id = String(json["id"].intValue)
        active = json["is_active"].bool ?? false
        email = json["mail"].string
        floor = json["floor"].string
        name = json["name"].string
        number = json["number"].string
        phone = json["phone"].string
        tags = json["tags"].string
        web = json["web"].string
        idNode = json["id_node"].string
        road = json["road"].string
        detail = json["description"].string
        code = json["code"].string
        for categoryJSON in json["categories"].array ?? [] {
            guard let id = categoryJSON["id"].int else { continue }
            guard let storeCategory = StoreCategory.find(byId: String(id), on: context) else { continue }
            addToCategories(storeCategory)
        }
        return true
    }

}
