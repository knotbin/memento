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
    var viewed: Bool
    
    init(timestamp: Date, link: String) {
        self.timestamp = timestamp
        self.link = link
        self.viewed = false
    }
}
