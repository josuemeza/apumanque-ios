//
//  UserScores+CoreDataClass.swift
//  
//
//  Created by Jimmy Hernandez on 22-07-18.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(UserScores)
public class UserScores: NSManagedObject {
    
    static func unitUserScores(on context: NSManagedObjectContext) -> UserScores? {
        let request: NSFetchRequest<UserScores> = UserScores.fetchRequest()
        return (try? context.fetch(request))?.first
    }
    
    
    func setData(from json: JSON) -> Bool {
        
        barcolorcode =  json["user_score_level"][0]["barcolorcode"].string!
        bgcolorcode =  json["user_score_level"][0]["bgcolorcode"].string!
        currentCampaign =  json["current_campaign"][0]["id"].int16!
        finishDate = json["current_campaign"][0]["finish_date"].string != nil ? Date.parse(stringDate: json["finish_date"].stringValue, format: "yyyy-MM-dd") as NSDate? : nil
        imageCampaign =  json["current_campaign"][0]["images"][0]["image"].string!
        isActive = json["current_campaign"][0]["is_active"].bool ?? false
        lower = json["user_score_level"][0]["lower"].int32!
        multiplicator = json["user_score_level"][0]["multiplicator"].string!
        nameType = json["user_score_level"][0]["name"].string!
        percentage = json["percentage"].float!
        startDate = json["current_campaign"][0]["start_date"].string != nil ? Date.parse(stringDate: json["start_date"].stringValue, format: "yyyy-MM-dd") as NSDate? : nil
        tickets = json["tickets"].int16!
        ticketsCampaign = json["tickets_campaign"].int16!
        upper = json["user_score_level"][0]["upper"].int32!
        userScore = json["user_score"].int16!
        userScoreCampaign = json["user_score_campaign"].int16!
        userScoreId = json["user_score_level"][0]["id"].int16!
        pdfFile = json["current_campaign"][0]["pdf_file"].string!
        level =  json["user_score_level"][0]["level"].int16!
        
        return true
    }
    
}
