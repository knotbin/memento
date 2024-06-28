//
//  Item.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/21/24.
//

import Foundation
import SwiftData

@Model
class Item: Identifiable {
    let id: UUID
    
    var timestamp: Date
    var link: String
    var url: URL
    var viewed: Bool
    var metadata: CodableLinkMetadata?
    
    init(link: String, url: URL, metadata: CodableLinkMetadata) {
        self.timestamp = Date()
        self.link = link
        self.url = url
        self.viewed = false
        self.metadata = metadata
        self.id = UUID()
    }
}
