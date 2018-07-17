//
//  User+CoreDataProperties.swift
//  
//
//  Created by Josue Meza Peña on 17-07-18.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var address: String?
    @NSManaged public var birthday: NSDate?
    @NSManaged public var commune: String?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var id: String?
    @NSManaged public var lastName: String?
    @NSManaged public var password: String?
    @NSManaged public var phone: String?
    @NSManaged public var region: String?
    @NSManaged public var rut: String?
    @NSManaged public var token: String?
    @NSManaged public var discounts: NSSet?

}

// MARK: Generated accessors for discounts
extension User {

    @objc(addDiscountsObject:)
    @NSManaged public func addToDiscounts(_ value: Discount)

    @objc(removeDiscountsObject:)
    @NSManaged public func removeFromDiscounts(_ value: Discount)

    @objc(addDiscounts:)
    @NSManaged public func addToDiscounts(_ values: NSSet)

    @objc(removeDiscounts:)
    @NSManaged public func removeFromDiscounts(_ values: NSSet)

}
