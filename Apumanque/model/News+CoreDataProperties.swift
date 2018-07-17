//
//  News+CoreDataProperties.swift
//  
//
//  Created by Josue Meza Peña on 16-07-18.
//
//

import Foundation
import CoreData


extension News {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<News> {
        return NSFetchRequest<News>(entityName: "News")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var start: NSDate?
    @NSManaged public var newsType: NewsType?
    @NSManaged public var newsFiles: NSSet?

}

// MARK: Generated accessors for newsFiles
extension News {

    @objc(addNewsFilesObject:)
    @NSManaged public func addToNewsFiles(_ value: NewsFile)

    @objc(removeNewsFilesObject:)
    @NSManaged public func removeFromNewsFiles(_ value: NewsFile)

    @objc(addNewsFiles:)
    @NSManaged public func addToNewsFiles(_ values: NSSet)

    @objc(removeNewsFiles:)
    @NSManaged public func removeFromNewsFiles(_ values: NSSet)

}
