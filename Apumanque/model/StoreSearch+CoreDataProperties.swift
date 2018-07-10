//
//  StoreSearch+CoreDataProperties.swift
//  
//
//  Created by Josue Meza Peña on 10-07-18.
//
//

import Foundation
import CoreData


extension StoreSearch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoreSearch> {
        return NSFetchRequest<StoreSearch>(entityName: "StoreSearch")
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var search: String?
    @NSManaged public var storeId: String?

}
