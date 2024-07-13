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
            phrases: ["Add a link to \(.applicationName)", "Make a new link in \(.applicationName)", "Create a new link in \(.applicationName)"],
            shortTitle: "Save Link",
            systemImageName: "link.badge.plus"
        )
        AppShortcut(
            intent: SaveNoteIntent(),
            phrases: ["Save a note to \(.applicationName)"],
            shortTitle: "Save Note",
            systemImageName: "note.text.badge.plus"
        )
        AppShortcut(
            intent: PasteLinkIntent(),
            phrases: ["Add a link in \(.applicationName) from my clipboard.", "Save a link in \(.applicationName) from paste."],
            shortTitle: "Paste Link",
            systemImageName: "clipboard"
        )
    }
}
