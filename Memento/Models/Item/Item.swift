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
    var id: UUID = UUID()
    
    var timestamp: Date = Date()
    var link: String?
    var url: URL?
    var viewed: Bool = false
    var metadata: CodableLinkMetadata?
    var note: String?
    
    init?(link: String?, note: String? = nil) async {
        var url: URL?
        if var fulllink = link, let compareLink = link {
            if compareLink.hasPrefix("https://www.") || compareLink.hasPrefix("http://www.") || compareLink.hasPrefix("https://") || compareLink.hasPrefix("http://") {
                fulllink = compareLink
            } else if compareLink.hasPrefix("www.") {
                fulllink = "https://\(compareLink)"
            } else {
                fulllink = "https://www.\(compareLink)"
            }
            url = URL(string: fulllink)
        }
        
        self.link = url?.absoluteString
        self.url = url
        if let fullurl = url {
            self.metadata = CodableLinkMetadata(metadata: await fetchMetadata(url: fullurl))
        }
        if let newnote = note, !newnote.isEmpty {
            self.note = newnote
        } else {
            self.note = nil
        }
    }
    
    init(_ note: String) {
        self.link = nil
        self.url = url
        self.metadata = nil
        self.note = note
    }
}
