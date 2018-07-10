//
//  StoreSearch+CoreDataClass.swift
//  
//
//  Created by Josue Meza Peña on 10-07-18.
//
//

import Foundation
import CoreData

@objc(StoreSearch)
public class StoreSearch: NSManagedObject {
    
    static func all(on context: NSManagedObjectContext) -> [StoreSearch]? {
        let request: NSFetchRequest<StoreSearch> = StoreSearch.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(StoreSearch.date), ascending: false)
        request.sortDescriptors = [sort]
        return try? context.fetch(request)
    }
    
    func store(on context: NSManagedObjectContext) -> Store? {
        guard let storeId = storeId, let id = Int(storeId) else { return nil }
        return Store.find(byId: id, on: context)
    }
    
    func save() throws {
        if let context = self.managedObjectContext {
            try context.save()
        }
    }
    
}
