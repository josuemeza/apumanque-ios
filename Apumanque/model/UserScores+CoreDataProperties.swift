//
//  UserScores+CoreDataProperties.swift
//  
//
//  Created by Jimmy Hernandez on 23-07-18.
//
//

import Foundation
import CoreData


extension UserScores {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserScores> {
        return NSFetchRequest<UserScores>(entityName: "UserScores")
    }

    @NSManaged public var barcolorcode: String?
    @NSManaged public var bgcolorcode: String?
    @NSManaged public var currentCampaign: Int16
    @NSManaged public var finishDate: NSDate?
    @NSManaged public var imageCampaign: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var lower: Int32
    @NSManaged public var multiplicator: String?
    @NSManaged public var nameType: String?
    @NSManaged public var percentage: Float
    @NSManaged public var startDate: NSDate?
    @NSManaged public var tickets: Int16
    @NSManaged public var ticketsCampaign: Int16
    @NSManaged public var upper: Int32
    @NSManaged public var userScore: Int16
    @NSManaged public var userScoreCampaign: Int16
    @NSManaged public var userScoreId: Int16
    @NSManaged public var pdfFile: String?
    @NSManaged public var level: Int16

}
