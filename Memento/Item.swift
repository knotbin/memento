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
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
