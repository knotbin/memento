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
            phrases: ["Add a link to \(.applicationName)", "Add \(\.$url) to \(.applicationName)", "Make a new link in \(.applicationName)", "Create a new link in \(.applicationName) from \(\.$url)"],
            shortTitle: "Add Link",
            systemImageName: "link.badge.plus"
        )
        AppShortcut(
            intent: LinkViewedIntent(),
            phrases: [
                "Mark a link I saved in \(.applicationName) as viewed",
                "Mark \(\.$link) as viewed in \(.applicationName)",
                "Set link in \(.applicationName) to viewed",
                "Change status of \(\.$link) to viewed in \(.applicationName)",
            ],
            shortTitle: "Mark Link as Viewed",
            systemImageName: "book"
        )
        AppShortcut(
            intent: DeleteLinkIntent(),
            phrases: ["Delete a link in \(.applicationName)"],
            shortTitle: "Delete Link",
            systemImageName: "trash"
        )
    }
}
