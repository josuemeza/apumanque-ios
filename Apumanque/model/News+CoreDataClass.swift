//
//  News+CoreDataClass.swift
//  
//
//  Created by Josue Meza Peña on 16-07-18.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(News)
public class News: NSManagedObject {
    
    var mainFile: NewsFile? {
        get {
            guard let newsFiles = newsFiles?.allObjects as? [NewsFile] else { return nil }
            let newsFile = newsFiles.compactMap { newsFile in
                newsFile.main ? newsFile : nil
            }.theOnlyOneElement
            return newsFile
        }
    }
    
    static func find(byId id: Int, on context: NSManagedObjectContext) -> News? {
        let request: NSFetchRequest<News> = News.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", String(id))
        guard let response = try? context.fetch(request) else { return nil }
        return response.theOnlyOneElement
    }
    
    static func all(on context: NSManagedObjectContext) -> [News]? {
        let request: NSFetchRequest<News> = News.fetchRequest()
        return try? context.fetch(request)
    }
    
    func setData(from json: JSON) -> Bool {
        id = String(json["id"].intValue)
        title = json["title"].string
        content = json["content"].string
        start = json["start"].string != nil ? Date.parse(stringDate: json["start"].stringValue, format: "yyyy-MM-dd'T'HH:mm:ssZ") as NSDate? : nil
        return true
    }

}
