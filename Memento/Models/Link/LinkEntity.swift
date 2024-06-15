//
//  LinkEntity.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/12/24.
//

import Foundation
import AppIntents

struct LinkEntity: AppEntity {
    
    @Property(title: "Title")
    var name: String?
    
    @Property(title: "URL")
    var link: String
    
    var imageData: Data?
    
    var id: Link.ID
    
    var viewed: Bool
    
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Link"
    
    var displayRepresentation: DisplayRepresentation {
        if let data = imageData {
            return DisplayRepresentation(title: LocalizedStringResource(stringLiteral: name ?? link), image: DisplayRepresentation.Image(data: data))
        } else {
            return DisplayRepresentation(title: LocalizedStringResource(stringLiteral: name ?? link), image: DisplayRepresentation.Image(named: "EmptyLink"))
        }
    }
    
    static var defaultQuery = LinkEntityQuery()
    
    init(link: Link) {
        self.id = link.id
        self.viewed = link.viewed
        self.name = link.metadata?.title ?? link.address
        self.link = link.address
        self.imageData = link.metadata?.siteImage ?? nil
    }
}
