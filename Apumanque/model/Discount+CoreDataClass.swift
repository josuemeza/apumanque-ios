//
//  Discount+CoreDataClass.swift
//  
//
//  Created by Josue Meza Peña on 31-05-18.
//
//

import Foundation
import CoreData
import SwiftyJSON
import SwiftyEssentials

@objc(Discount)
public class Discount: NSManagedObject {
    
    // MARK: - Enumerations
    
    enum ValueColor: String {
        case red = "rojo", green = "verde", orange = "naranja"
        var color: UIColor {
            switch self {
            case .red:
                return UIColor(red: 232/255, green: 0/255, blue: 58/255, alpha: 1)
            case .green:
                return UIColor(red: 30/255, green: 155/255, blue: 132/255, alpha: 1)
            case .orange:
                return UIColor(red: 244/255, green: 85/255, blue: 22/255, alpha: 1)
            }
        }
    }
    
    // MARK: - Attributes
    
    var valueColor: ValueColor? {
        get {
            if let floorString = store?.floor, Int(floorString) == 0 { return ValueColor.orange }
            guard let color = tagColor else { return nil }
            return ValueColor(rawValue: color)
        }
        set {
            tagColor = newValue?.rawValue
        }
    }
    
    var valueText: String? {
        get {
            guard let color = valueColor else { return nil }
            switch color {
            case .red:
                guard let value = valuePercent else { return "S/N" }
                return "\(value)%"
            case .green:
                return "Dcto"
            case .orange:
                return "LE"
            }
        }
    }
    
    // MARK: - Methods
    
    static func all(featured: Bool, on context: NSManagedObjectContext) -> [Discount]? {
        let request: NSFetchRequest<Discount> = Discount.fetchRequest()
        request.predicate = NSPredicate(format: "featured == %@", NSNumber(value: featured))
        return try? context.fetch(request)
    }
    
    static func find(byId id: Int, on context: NSManagedObjectContext) -> Discount? {
        let request: NSFetchRequest<Discount> = Discount.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", String(id))
        guard let response = try? context.fetch(request) else { return nil }
        return response.theOnlyOneElement
    }

    func setData(from json: JSON, featured: Bool) -> Bool {
        guard let context = managedObjectContext else { return false }
        self.featured = featured
        id = String(json["id"].intValue)
        title = json["title"].string
        valuePercent = json["value_percent"].string
        tagColor = json["tag_color"].string
        detail = json["description"].string
        code = json["code"].string
        resume = json["resume"].string
        conditions = json["conditions"].string
        active = json["is_active"].bool ?? false
        imageUrl = json["images"][0]["image"].string
        startDate = json["start_date"].string != nil ? Date.parse(stringDate: json["start_date"].stringValue, format: "yyyy-MM-dd'T'HH:mm:ssZ") as NSDate? : nil
        expireDate = json["expire_date"].string != nil ? Date.parse(stringDate: json["expire_date"].stringValue, format: "yyyy-MM-dd'T'HH:mm:ssZ") as NSDate? : nil
        store = Store.find(byId: json["id_store"]["id"].intValue, on: context)
        return true
    }
    
}
