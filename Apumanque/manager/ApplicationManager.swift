//
//  ApplicationManager.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 16-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import Foundation

class ApplicationManager {
    
    /// Home categories
    var homeCategories = [HomeCategory]()
    
    // MARK: - Singleton definition
    
    /// Singleton definition
    static let singleton = ApplicationManager()
    
    /// Singleton constructor
    private init() {}
    
}
