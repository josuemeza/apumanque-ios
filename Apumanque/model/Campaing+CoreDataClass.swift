//
//  Campaing+CoreDataClass.swift
//  
//
//  Created by Jimmy Hernandez on 08-07-18.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Campaing)
public class Campaing: NSManagedObject {
    
    static func unitCampaing(on context: NSManagedObjectContext) -> Campaing? {
        let request: NSFetchRequest<Campaing> = Campaing.fetchRequest()
        return (try? context.fetch(request))?.first
    }
    
    func setData(from json: JSON) -> Bool {
            contentCampaign = json["campaign"].string
            code = Int16(json["code"].intValue)
            finishDate = json["finish_date"].string != nil ? Date.parse(stringDate: json["finish_date"].stringValue, format: "yyyy-MM-dd") as NSDate? : nil
            imageUrl = json["images"][1]["image"].string
            title = json["title"].string
            pdfFile = json["pdf_file"].string
            startDate = json["start_date"].string != nil ? Date.parse(stringDate: json["finish_date"].stringValue, format: "yyyy-MM-dd") as NSDate? : nil
            title = json["title"].string
            id = String(json["id"].intValue)
        return true
    }
    
}
