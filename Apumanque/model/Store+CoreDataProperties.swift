//
//  Store+CoreDataProperties.swift
//  
//
//  Created by Josue Meza Peña on 10-07-18.
//
//

import Foundation
import CoreData


extension Store {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Store> {
        return NSFetchRequest<Store>(entityName: "Store")
    }

    @NSManaged public var active: Bool
    @NSManaged public var code: String?
    @NSManaged public var detail: String?
    @NSManaged public var email: String?
    @NSManaged public var floor: String?
    @NSManaged public var id: String?
    @NSManaged public var idNode: String?
    @NSManaged public var name: String?
    @NSManaged public var number: String?
    @NSManaged public var phone: String?
    @NSManaged public var road: String?
    @NSManaged public var tags: String?
    @NSManaged public var web: String?
    @NSManaged public var categories: NSSet?
    @NSManaged public var discounts: NSSet?

}

// MARK: Generated accessors for categories
extension Store {

    @objc(addCategoriesObject:)
    @NSManaged public func addToCategories(_ value: StoreCategory)

    @objc(removeCategoriesObject:)
    @NSManaged public func removeFromCategories(_ value: StoreCategory)

    @objc(addCategories:)
    @NSManaged public func addToCategories(_ values: NSSet)

    @objc(removeCategories:)
    @NSManaged public func removeFromCategories(_ values: NSSet)

}

// MARK: Generated accessors for discounts
extension Store {

    @objc(addDiscountsObject:)
    @NSManaged public func addToDiscounts(_ value: Discount)

    @objc(removeDiscountsObject:)
    @NSManaged public func removeFromDiscounts(_ value: Discount)

    @objc(addDiscounts:)
    @NSManaged public func addToDiscounts(_ values: NSSet)

    @objc(removeDiscounts:)
    @NSManaged public func removeFromDiscounts(_ values: NSSet)

}
