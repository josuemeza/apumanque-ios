//
//  NewsType+CoreDataClass.swift
//  
//
//  Created by Josue Meza Peña on 16-07-18.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(NewsType)
public class NewsType: NSManagedObject {
    
    static func find(byId id: Int, on context: NSManagedObjectContext) -> NewsType? {
        let request: NSFetchRequest<NewsType> = NewsType.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", String(id))
        guard let response = try? context.fetch(request) else { return nil }
        return response.theOnlyOneElement
    }
    
    func setData(from json: JSON) -> Bool {
        id = String(json["id"].intValue)
        name = json["name"].string
        return true
    }

}
