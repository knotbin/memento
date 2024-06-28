//
//  MementoShortcuts.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/14/24.
//

import Foundation
import AppIntents

struct MementoShortcuts: AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: SaveItemIntent(),
            phrases: ["Add an item to \(.applicationName)", "Make a new item in \(.applicationName)", "Create a new item in \(.applicationName)"],
            shortTitle: "Add Item",
            systemImageName: "plus"
        )
        AppShortcut(
            intent: DeleteItemIntent(),
            phrases: ["Delete an item in \(.applicationName)"],
            shortTitle: "Delete Item",
            systemImageName: "trash"
        )
        AppShortcut(
            intent: PasteItemIntent(),
            phrases: ["Add an item in \(.applicationName) from my clipboard.", "Save an item in \(.applicationName) from paste."],
            shortTitle: "Save Item from Clipboard",
            systemImageName: "clipboard"
        )
    }
}
