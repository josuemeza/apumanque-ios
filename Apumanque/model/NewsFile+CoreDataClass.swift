//
//  NewsFile+CoreDataClass.swift
//  
//
//  Created by Josue Meza Peña on 16-07-18.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(NewsFile)
public class NewsFile: NSManagedObject {
    
    static func find(byId id: Int, on context: NSManagedObjectContext) -> NewsFile? {
        let request: NSFetchRequest<NewsFile> = NewsFile.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", String(id))
        guard let response = try? context.fetch(request) else { return nil }
        return response.theOnlyOneElement
    }
    
    func setData(from json: JSON) -> Bool {
        id = String(json["id"].intValue)
        url = json["file"].string
        main = (json["image_type"].string ?? "Secundaria") == "Principal"
        return true
    }

}
