//
//  Help+CoreDataProperties.swift
//  
//
//  Created by Jimmy Hernandez on 17-07-18.
//
//

import Foundation
import CoreData


extension Help {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Help> {
        return NSFetchRequest<Help>(entityName: "Help")
    }

    @NSManaged public var question: String?
    @NSManaged public var answer: String?
    @NSManaged public var order: Int16

}
