//
//  Note.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/24/24.
//

import Foundation
import SwiftData

@Model
class Note: Identifiable {
    let id: UUID
    
    let timestamp: Date
    var text: String
    var viewed: Bool
    
    init(_ text: String) {
        self.id = UUID()
        self.timestamp = Date()
        self.text = text
        self.viewed = false
    }
}
