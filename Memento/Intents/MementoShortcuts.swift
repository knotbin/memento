//
//  MementoShortcuts.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/14/24.
//

import Foundation
import AppIntents

struct MementoShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: LinkViewedIntent(),
            phrases: [
                "Mark a link I saved in \(.applicationName) as viewed",
                "Mark \(\.$link) as viewed in \(.applicationName)",
                "Set link in \(.applicationName) to viewed",
                "Change status of \(\.$link) to viewed in \(.applicationName)",
                "Mark saved link as viewed in \(.applicationName)",
                "Update \(\.$link) to viewed in \(.applicationName)",
                "Flag link as viewed in \(.applicationName)",
                "Set \(\.$link) status to viewed in \(.applicationName)",
                "Mark the link I saved in \(.applicationName) as viewed",
                "Mark as viewed the link saved in \(.applicationName)",
                "Change the link status to viewed in \(.applicationName)",
                "Update the link status to viewed in \(.applicationName)",
                "Mark a link I saved as viewed in \(.applicationName)",
                "Mark the link \(\.$link) as viewed in \(.applicationName)",
                "Set the link in \(.applicationName) to viewed",
                "Change the status of \(\.$link) to viewed in \(.applicationName)",
                "Mark the saved link as viewed in \(.applicationName)",
                "Update the link \(\.$link) to viewed in \(.applicationName)",
                "Flag the link as viewed in \(.applicationName)",
                "Set the status of \(\.$link) to viewed in \(.applicationName)",
                "Mark my saved link in \(.applicationName) as viewed",
                "Mark as viewed my saved link in \(.applicationName)",
                "Change status of my link to viewed in \(.applicationName)",
                "Update my link \(\.$link) to viewed in \(.applicationName)",
                "Flag my saved link as viewed in \(.applicationName)",
                "Set my link \(\.$link) status to viewed in \(.applicationName)",
                "Mark link as viewed in \(.applicationName)",
                "Set \(\.$link) in \(.applicationName) to viewed",
                "Change status to viewed for \(\.$link) in \(.applicationName)",
                "Mark \(\.$link) as viewed in \(.applicationName)",
                "Update status of \(\.$link) to viewed in \(.applicationName)",
                "Flag \(\.$link) as viewed in \(.applicationName)",
                "Set status of \(\.$link) to viewed in \(.applicationName)",
                "Mark a link in \(.applicationName) as viewed",
                "Set a link \(\.$link) to viewed in \(.applicationName)",
                "Change the status of a link to viewed in \(.applicationName)",
                "Mark saved link \(\.$link) as viewed in \(.applicationName)",
                "Update status of the link \(\.$link) to viewed in \(.applicationName)",
                "Flag the saved link as viewed in \(.applicationName)",
                "Set a saved link \(\.$link) status to viewed in \(.applicationName)"
            ],

            shortTitle: "Mark Link as Viewed",
            systemImageName: "book"
        );
        AppShortcut(
            intent: SaveLinkIntent(),
            phrases: ["Add a link to \(.applicationName)"],
            shortTitle: "Add Link",
            systemImageName: "link.badge.plus"
        )
    }
}
