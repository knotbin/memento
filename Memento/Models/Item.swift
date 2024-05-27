//
//  Item.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/21/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    var link: String
    var name : String
    
    init(timestamp: Date, link: String, name: String) {
        self.timestamp = timestamp
        self.link = link
        self.name = name
    }
}
