//
//  Campaing+CoreDataProperties.swift
//  
//
//  Created by Jimmy Hernandez on 08-07-18.
//
//

import Foundation
import CoreData


extension Campaing {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Campaing> {
        return NSFetchRequest<Campaing>(entityName: "Campaing")
    }

    @NSManaged public var contentCampaign: String?
    @NSManaged public var code: Int16
    @NSManaged public var finishDate: NSDate?
    @NSManaged public var imageUrl: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var pdfFile: String?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var id: String?

}
