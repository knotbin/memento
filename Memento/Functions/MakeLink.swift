//
//  MakeItem.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/4/24.
//

import Foundation
import LinkPresentation

func makeLink(address: String) async -> Link? {
    var fulladdress = address
    
    if address.hasPrefix("https://www.") || address.hasPrefix("http://www.") || address.hasPrefix("https://") || address.hasPrefix("http://") {
        fulladdress = address
    } else if address.hasPrefix("www.") {
        fulladdress = "https://\(address)"
    } else {
        fulladdress = "https://www.\(address)"
    }
    guard let url = URL(string: fulladdress) else {
        return nil
    }
    
    let metadata = await fetchMetadata(url: url)
    
    let link = Link(address: fulladdress, url: url, metadata: CodableLinkMetadata(metadata: metadata))
    
    return link
}
