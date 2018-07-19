//
//  Discount+CoreDataProperties.swift
//  
//
//  Created by Josue Meza Peña on 18-07-18.
//
//

import Foundation
import CoreData


extension Discount {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Discount> {
        return NSFetchRequest<Discount>(entityName: "Discount")
    }

    @NSManaged public var active: Bool
    @NSManaged public var code: String?
    @NSManaged public var conditions: String?
    @NSManaged public var detail: String?
    @NSManaged public var expireDate: NSDate?
    @NSManaged public var featured: Bool
    @NSManaged public var id: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var resume: String?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var tagColor: String?
    @NSManaged public var title: String?
    @NSManaged public var valuePercent: String?
    @NSManaged public var store: Store?
    @NSManaged public var user: User?

}
