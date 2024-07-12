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
    var id: UUID
    
    var timestamp: Date
    var link: String?
    var url: URL?
    var viewed: Bool
    var metadata: CodableLinkMetadata?
    var note: String?
    
    init?(link: String, note: String? = nil) async {
        var fulllink = link
        
        if link.hasPrefix("https://www.") || link.hasPrefix("http://www.") || link.hasPrefix("https://") || link.hasPrefix("http://") {
            fulllink = link
        } else if link.hasPrefix("www.") {
            fulllink = "https://\(link)"
        } else {
            fulllink = "https://www.\(link)"
        }
        guard let url = URL(string: fulllink) else {
            return nil
        }
        
        let metadata = await fetchMetadata(url: url)
        
        self.id = UUID()
        self.timestamp = Date()
        self.viewed = false
        self.link = fulllink
        self.url = url
        self.metadata = CodableLinkMetadata(metadata: metadata)
        if let newnote = note, !newnote.isEmpty {
            self.note = newnote
        } else {
            self.note = nil
        }
    }
    
    init(_ note: String) {
        self.id = UUID()
        self.timestamp = Date()
        self.viewed = false
        self.link = nil
        self.url = url
        self.metadata = nil
        self.note = note
    }
}
