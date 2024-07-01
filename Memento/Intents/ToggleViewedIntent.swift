//
//  ToggleViewedIntent.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 7/1/24.
//

import Foundation
import AppIntents
import SwiftData

struct ToggleViewedIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Item Viewed"
    
    @Parameter(title: "Item")
    var item: ItemEntity?
    
    init(item: Item) {
        self.item = ItemEntity(item: item)
    }
    
    init() {}
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let entities = try await ItemEntityQuery().suggestedEntities()
        guard !entities.isEmpty else {
            return .result(dialog: "There are no items to toggle.")
        }
        var enteredItem: ItemEntity
        if let item = item {
            enteredItem = item
        } else {
            enteredItem = try await $item.requestDisambiguation(
                among: ItemEntityQuery().suggestedEntities(),
                dialog: "Which item would you like to toggle viewed?"
            )
        }
        let context = ModelContext(ConfigureModelContainer())
        context.autosaveEnabled = true
        let items = try? context.fetch(FetchDescriptor<Item>())
        guard let item = items?.filter({ $0.id == enteredItem.id }).first else {
            return .result(dialog: "An Error Occured")
        }
        item.viewed.toggle()
        try context.save()
        UpdateAll()
        return .result(dialog: "Okay, \(enteredItem.name ?? enteredItem.item)'s view state has been toggled.")
    }
    
    static var parameterSummary: some ParameterSummary {
            Summary("Toggle \(\.$item)'s view state.")
    }
}
