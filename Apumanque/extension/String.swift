//
//  String.swift
//  Apumanque
//
//  Created by Josue Meza Peña on 16-05-18.
//  Copyright © 2018 Josue Meza Peña. All rights reserved.
//

import Foundation
import SwiftSoup

extension String {
    
    var parsedOnDocument: String? {
        get {
            do {
                let doc: Document = try SwiftSoup.parse(self)
                return try doc.text()
            } catch {
                return nil
            }
        }
    }
    
}
