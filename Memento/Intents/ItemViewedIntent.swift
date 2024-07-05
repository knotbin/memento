//
//  ItemViewedIntent.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/13/24.
//

import Foundation
import AppIntents
import SwiftData

struct ItemViewedIntent: AppIntent {
    static var title: LocalizedStringResource = "Mark Item Viewed"
    
    @Parameter(title: "Item")
    var item: ItemEntity?
    
    init(item: Item) {
        self.item = ItemEntity(item: item)
    }
    
    init() {}
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let entities = try await ItemEntityQuery().suggestedEntities().filter({$0.viewed == false})
        guard !entities.isEmpty else {
            return .result(dialog: "There are no unviewed items to mark.")
        }
        var enteredItem: ItemEntity
        if let item = item {
            enteredItem = item
        } else {
            enteredItem = try await $item.requestDisambiguation(
                among: ItemEntityQuery().suggestedEntities(),
                dialog: "Which item would you like to mark viewed?"
            )
        }
        let context = ModelContext(ConfigureModelContainer())
        context.autosaveEnabled = true
        let items = try? context.fetch(FetchDescriptor<Item>())
        guard let item = items?.filter({ $0.id == enteredItem.id }).first else {
            return .result(dialog: "An Error Occured")
        }
        if item.viewed == true {
            return .result(dialog: "Item is already viewed")
        }
        item.viewed = true
        try context.save()
        UpdateAll()
        return .result(dialog: "Okay, \(enteredItem.name ?? enteredItem.link ?? "the note") has been marked as viewed.")
    }
    
    static var parameterSummary: some ParameterSummary {
            Summary("Mark \(\.$item) as viewed.")
    }
}
