//
//  Help+CoreDataClass.swift
//  
//
//  Created by Jimmy Hernandez on 18-07-18.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Help)
public class Help: NSManagedObject {
    
    var questionsItems = [Help]()
    
    static func all(on context: NSManagedObjectContext) -> [Help]? {
        let request: NSFetchRequest<Help> = Help.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Help.order), ascending: true)
        request.sortDescriptors = [sort]
        return try? context.fetch(request)
    }
    
    func setData(from json: JSON) -> Bool {
        question = json["name"].string
        answer = json["texts"][0]["description"].string
        order = Int16(json["order"].intValue)
        return true
    }
    
    
}
