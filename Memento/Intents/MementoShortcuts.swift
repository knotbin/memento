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
            shortTitle: "Add Link",
            systemImageName: "link.badge.plus"
        )
        AppShortcut(
            intent: DeleteLinkIntent(),
            phrases: ["Delete a link in \(.applicationName)"],
            shortTitle: "Delete Link",
            systemImageName: "trash"
        )
    }
}
