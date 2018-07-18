//
//  NewsType+CoreDataProperties.swift
//  
//
//  Created by Josue Meza Peña on 16-07-18.
//
//

import Foundation
import CoreData


extension NewsType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsType> {
        return NSFetchRequest<NewsType>(entityName: "NewsType")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var news: NSSet?

}

// MARK: Generated accessors for news
extension NewsType {

    @objc(addNewsObject:)
    @NSManaged public func addToNews(_ value: News)

    @objc(removeNewsObject:)
    @NSManaged public func removeFromNews(_ value: News)

    @objc(addNews:)
    @NSManaged public func addToNews(_ values: NSSet)

    @objc(removeNews:)
    @NSManaged public func removeFromNews(_ values: NSSet)

}
