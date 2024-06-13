//
//  Item.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/21/24.
//

import Foundation
import SwiftData
import LinkPresentation
import AppIntents
import SwiftUI

@Model
@available(iOS 16.0, *)
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


struct ItemEntity: AppEntity {
    
    @Property(title: "Title")
    var name: String?
    
    @Property(title: "URL")
    var link: String
    
    var imageData: Data?
    
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Link"
    
    var displayRepresentation: DisplayRepresentation {
        if let data = imageData {
            return DisplayRepresentation(title: LocalizedStringResource(stringLiteral: name ?? link), image: DisplayRepresentation.Image(data: data))
        } else {
            return DisplayRepresentation(title: LocalizedStringResource(stringLiteral: name ?? link), image: DisplayRepresentation.Image(named: "EmptyLink"))
        }
    }
    
    var id: Item.ID
    
    static var defaultQuery = ItemEntityQuery()
    
    init(item: Item) {
        self.name = item.metadata?.title ?? item.link
        self.id = item.id
        self.link = item.link
        guard let data = item.metadata?.siteImage else {
            self.imageData = nil
            return
        }
        self.imageData = data
    }
}

struct ItemEntityQuery: EntityQuery {
    func entities(for identifiers: [ItemEntity.ID]) async throws -> [ItemEntity] {
        @Query var items: [Item]
        let filtereditems = items.compactMap { item in
            return identifiers.contains(item.id) ? item : nil
        }
        return filtereditems.map { ItemEntity(item: $0) }
    }
}

extension ItemEntityQuery: EntityStringQuery {
    func entities(matching string: String) async throws -> [ItemEntity] {
        @Query var items: [Item]
        var map = items.filter {
            if (($0.metadata?.title?.contains(string)) != nil) {
                return true
            }
        }.map { ItemEntity(item: $0) }
        return map
    }
}
