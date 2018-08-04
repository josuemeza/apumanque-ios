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
                let document: Document = try SwiftSoup.parse(self)
                if let brs = try? document.select("br") {
                    brs.forEach { br in _ = try? br.html("{{br}}") }
                }
                guard let text = try? document.text() else { return nil }
                let parsed = text.replacingOccurrences(of: "{{br}}", with: "\n")
                return parsed
            } catch {
                return nil
            }
        }
    }
    
}
