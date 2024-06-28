//
//  ItemEntityQuery.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/12/24.
//

import Foundation
import AppIntents
import SwiftData

struct ItemEntityQuery: EntityQuery {
    func entities(for identifiers: [ItemEntity.ID]) async throws -> [ItemEntity] {
        var items: [Item] = []
        let modelContainer = ConfigureModelContainer()
        let modelContext = ModelContext(modelContainer)
        let fetchDescriptor = FetchDescriptor<Item>()
        do {
             items = try modelContext.fetch(fetchDescriptor)
        }
        
        let filteredItems = items.filter { identifiers.contains($0.id) }
        return filteredItems.map { ItemEntity(item: $0) }
    }
    func suggestedEntities() async throws -> [ItemEntity] {
        var items: [Item] = []
        let modelContainer = ConfigureModelContainer()
        let modelContext = ModelContext(modelContainer)
        let fetchDescriptor = FetchDescriptor<Item>()
        do {
             items = try modelContext.fetch(fetchDescriptor)
        }
        return items.map { ItemEntity(item: $0) }
    }
}

extension ItemEntityQuery: EntityStringQuery {
    func entities(matching string: String) async throws -> [ItemEntity] {
        var items: [Item] = []
        let modelContainer = ConfigureModelContainer()
        let modelContext = ModelContext(modelContainer)
        let fetchDescriptor = FetchDescriptor<Item>()
        do {
             items = try modelContext.fetch(fetchDescriptor)
        }
        let filteredItems = items.filter { item in
            guard let title = item.metadata?.title else {
                return false
            }
            return title.contains(string)
        }
        return filteredItems.map { ItemEntity(item: $0) }
    }
}
