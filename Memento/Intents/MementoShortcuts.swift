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
            phrases: ["Mark a link I saved in \(.applicationName) as viewed"],
            shortTitle: "Mark Link as Viewed",
            systemImageName: "book"
        )
    }
}
