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
        let array = json["results"][0]["config"][1]["menues"][2]["options"].arrayValue
        for item in array {
            let questions = Help(context: managedObjectContext!)
            questions.question = item["name"].string
            questions.answer = item["texts"][0]["description"].string
            questions.order = Int16(item["order"].intValue)
            
            questionsItems.append(questions)
            print("AQUI ESTAMOS")
        }
        
        return true
    }
    
    
}
