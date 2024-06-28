//
//  PasteItemIntent.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/23/24.
//

import Foundation
import AppIntents
import SwiftData

struct PasteItemIntent: AppIntent {
    static var title: LocalizedStringResource = "Save Item From Clipboard"
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let context = ModelContext(ConfigureModelContainer())
        context.autosaveEnabled = true
        guard let item = await ItemFromPaste() else {
            return .result(
                dialog: "There is no available clipboard text."
            )
        }
        context.insert(item)
        return .result(dialog: "OK, \(item.metadata?.title ?? item.address) has been added.")
    }
}
