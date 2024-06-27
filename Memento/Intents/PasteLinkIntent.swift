//
//  PasteLinkIntent.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/23/24.
//

import Foundation
import AppIntents
import SwiftData

struct PasteLinkIntent: AppIntent {
    static var title: LocalizedStringResource = "Save Link From Clipboard"
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let context = ModelContext(ConfigureModelContainer())
        context.autosaveEnabled = true
        guard let link = await LinkFromPaste() else {
            return .result(
                dialog: "There is no available clipboard text."
            )
        }
        context.insert(link)
        return .result(dialog: "OK, \(link.metadata?.title ?? link.address) has been added.")
    }
}
