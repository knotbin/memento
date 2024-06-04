//
//  MakeItem.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/4/24.
//

import Foundation
import LinkPresentation

public func makeItem(link: String) async -> Item? {
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
    
    var metadata = await fetchMetadata(url: url)
    
    let item = Item(link: fulllink, url: url, metadata: CodableLinkMetadata(metadata: metadata))
    
    return item
}
