//
//  StoreCategory+CoreDataProperties.swift
//  
//
//  Created by Josue Meza Peña on 29-05-18.
//
//

import Foundation
import CoreData


extension StoreCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoreCategory> {
        return NSFetchRequest<StoreCategory>(entityName: "StoreCategory")
    }

    @NSManaged public var id: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var active: Bool
    @NSManaged public var code: String?
    @NSManaged public var stores: NSSet?

}

// MARK: Generated accessors for stores
extension StoreCategory {

    @objc(addStoresObject:)
    @NSManaged public func addToStores(_ value: Store)

    @objc(removeStoresObject:)
    @NSManaged public func removeFromStores(_ value: Store)

    @objc(addStores:)
    @NSManaged public func addToStores(_ values: NSSet)

    @objc(removeStores:)
    @NSManaged public func removeFromStores(_ values: NSSet)

}
