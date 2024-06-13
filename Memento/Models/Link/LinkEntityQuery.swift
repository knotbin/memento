//
//  LinkEntityQuery.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/12/24.
//

import Foundation
import AppIntents
import SwiftData

struct LinkEntityQuery: EntityQuery {
    func entities(for identifiers: [LinkEntity.ID]) async throws -> [LinkEntity] {
        var links: [Link] = []
        let modelContainer = ConfigureModelContainer()
        let modelContext = ModelContext(modelContainer)
        let fetchDescriptor = FetchDescriptor<Link>()
        do {
             links = try modelContext.fetch(fetchDescriptor)
        }
        
        let filteredLinks = links.filter { identifiers.contains($0.id) }
        return filteredLinks.map { LinkEntity(link: $0) }
    }
}

extension LinkEntityQuery: EntityStringQuery {
    func entities(matching string: String) async throws -> [LinkEntity] {
        var links: [Link] = []
        let modelContainer = ConfigureModelContainer()
        let modelContext = ModelContext(modelContainer)
        let fetchDescriptor = FetchDescriptor<Link>()
        do {
             links = try modelContext.fetch(fetchDescriptor)
        }
        let filteredLinks = links.filter { link in
            guard let title = link.metadata?.title else {
                return false
            }
            return title.contains(string)
        }
        return filteredLinks.map { LinkEntity(link: $0) }
    }
}
