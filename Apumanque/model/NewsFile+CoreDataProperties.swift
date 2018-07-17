//
//  NewsFile+CoreDataProperties.swift
//  
//
//  Created by Josue Meza Peña on 16-07-18.
//
//

import Foundation
import CoreData


extension NewsFile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsFile> {
        return NSFetchRequest<NewsFile>(entityName: "NewsFile")
    }

    @NSManaged public var id: String?
    @NSManaged public var url: String?
    @NSManaged public var main: Bool
    @NSManaged public var news: News?

}
