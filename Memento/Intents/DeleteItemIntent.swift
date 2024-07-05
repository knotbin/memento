//
//  DeleteItemIntent.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/17/24.
//

import Foundation
import AppIntents
import SwiftData

struct DeleteItemIntent: AppIntent {
    static let title: LocalizedStringResource = "Delete Item"
    
    @Parameter(title: "Item")
    var item: ItemEntity?
    
    init(item: Item) {
        self.item = ItemEntity(item: item)
    }
    
    init() {}
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let entities = try await ItemEntityQuery().suggestedEntities()
        guard !entities.isEmpty else {
            return .result(dialog: "There are no items to delete.")
        }
        var enteredItem: ItemEntity
        if let item = item {
            enteredItem = item
        } else {
            enteredItem = try await $item.requestDisambiguation(
                among: ItemEntityQuery().suggestedEntities(),
                dialog: "Which item would you like to delete?"
            )
        }
        let context = ModelContext(ConfigureModelContainer())
        context.autosaveEnabled = true
        let items = try? context.fetch(FetchDescriptor<Item>())
        guard let item = items?.filter({ $0.id == enteredItem.id }).first else {
            return .result(dialog: "An Error Occured")
        }
        context.delete(item)
        try context.save()
        UpdateAll()
        return .result(dialog: "Okay, \(enteredItem.name ?? enteredItem.link ?? "the note") has been deleted.")
    }
    
    static var parameterSummary: some ParameterSummary {
            Summary("Delete \(\.$item)")
    }
}
