//
//  Item.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/21/24.
//

import Foundation
import SwiftData

@Model
class Link: Identifiable {
    let id: UUID
    
    var timestamp: Date
    var address: String
    var url: URL
    var viewed: Bool
    var metadata: CodableLinkMetadata?
    
    init(address: String, url: URL, metadata: CodableLinkMetadata) {
        self.timestamp = Date()
        self.address = address
        self.url = url
        self.viewed = false
        self.metadata = metadata
        self.id = UUID()
    }
}
