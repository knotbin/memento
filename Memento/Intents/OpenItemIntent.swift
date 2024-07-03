//
//  OpenItem.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 7/2/24.
//

import Foundation
import AppIntents
import SwiftData

@available(iOS 18.0, *)
struct OpenItemIntent: AppIntent, OpensIntent {
    var value: Never?
    
    static var title: LocalizedStringResource = "Open Item"
    
    @Parameter(title: "Item")
    var target: ItemEntity?
    
    func perform() async throws -> some OpensIntent {
        let entities = try await ItemEntityQuery().suggestedEntities().sorted { (lhs: ItemEntity, rhs: ItemEntity) in
            if lhs.viewed == rhs.viewed {
                return lhs.timestamp > rhs.timestamp
            }
            return !lhs.viewed && rhs.viewed
        }
        guard !entities.isEmpty else {
            throw urlError(linkUsed: target?.item)
        }
        var enteredItem: ItemEntity
        if let item = target {
            enteredItem = item
        } else {
            enteredItem = try await $target.requestDisambiguation(
                among: ItemEntityQuery().suggestedEntities(),
                dialog: "Which item would you like to open?"
            )
        }
        let context = ModelContext(ConfigureModelContainer())
        context.autosaveEnabled = true
        
        let items = try? context.fetch(FetchDescriptor<Item>())
        guard let item = items?.filter({ $0.id == enteredItem.id }).first else {
            throw dataError()
        }
        item.viewed.toggle()
        try context.save()
        UpdateAll()

        return .result(opensIntent: OpenURLIntent(item.url))
    }
    struct urlError: Error {
        let linkUsed: String?
    }
    struct dataError: Error {}
}
