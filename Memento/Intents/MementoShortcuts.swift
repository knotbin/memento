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
            intent: SaveLinkIntent(),
            phrases: ["Add an item to \(.applicationName)", "Make a new item in \(.applicationName)", "Create a new item in \(.applicationName)"],
            shortTitle: "Save Link",
            systemImageName: "plus"
        )
        AppShortcut(
            intent: SaveNoteIntent(),
            phrases: ["Save a note to \(.applicationName)"],
            shortTitle: "Save Note",
            systemImageName: "note.text.badge.plus"
        )
        AppShortcut(
            intent: PasteLinkIntent(),
            phrases: ["Add an item in \(.applicationName) from my clipboard.", "Save an item in \(.applicationName) from paste."],
            shortTitle: "Paste Link",
            systemImageName: "clipboard"
        )
    }
}
