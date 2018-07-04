//
//  HomeCategory+CoreDataProperties.swift
//  
//
//  Created by Josue Meza Peña on 16-05-18.
//
//

import Foundation
import CoreData


extension HomeCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HomeCategory> {
        return NSFetchRequest<HomeCategory>(entityName: "HomeCategory")
    }

    @NSManaged public var title: String?
    @NSManaged public var subtitle: String?
    @NSManaged public var background: NSData?

}
