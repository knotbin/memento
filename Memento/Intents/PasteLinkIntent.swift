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
        let pasteText = paste()
        guard let address: String = pasteText else {
            return .result(dialog: "No Text in Clipboard.")
        }
        guard let link = await makeLink(address: address) else {
            return .result(dialog: "An error occured. Please try again.")
        }
        context.insert(link)
        return .result(dialog: "OK, \(link.metadata?.title ?? link.address) has been added.")
    }
}
