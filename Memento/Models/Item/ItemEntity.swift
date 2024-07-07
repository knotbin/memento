//
//  ItemEntity.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/12/24.
//

import Foundation
import AppIntents

struct ItemEntity: URLRepresentableEntity {
    @available(iOS 18.0, *)
    static var urlRepresentation: URLRepresentation = URLRepresentation("memento://item/\(.id)")
    
    
    @Property(title: "Title")
    var name: String?
    
    @Property(title: "URL")
    var link: String?
    
    @Property(title: "Note")
    var note: String?
    
    var imageData: Data?
    
    var id: Item.ID
    
    var viewed: Bool
    
    var timestamp: Date
    
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Item"
    
    var displayRepresentation: DisplayRepresentation {
        if let data = imageData {
            return DisplayRepresentation(title: LocalizedStringResource(stringLiteral: name ?? link ?? note ?? ""), image: DisplayRepresentation.Image(data: data))
        } else {
            return DisplayRepresentation(title: LocalizedStringResource(stringLiteral: name ?? link ?? note ?? ""))
        }
    }
    
    static var defaultQuery = ItemEntityQuery()
    
    init(item: Item) {
        self.id = item.id
        self.viewed = item.viewed
        self.timestamp = item.timestamp
        self.name = item.metadata?.title ?? item.link
        self.link = item.link
        self.imageData = item.metadata?.siteImage ?? nil
    }
}
