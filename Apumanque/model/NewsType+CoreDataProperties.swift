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
    @NSManaged public var news: News?

}
