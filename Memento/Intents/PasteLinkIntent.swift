//
//  PasteLinkIntent.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/23/24.
//

import Foundation
import AppIntents
import SwiftData
import SwiftUI

struct PasteLinkIntent: AppIntent {
    static var title: LocalizedStringResource = "Save Clipboard Link"
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let pasteboard = UIPasteboard.general
        let context = ModelContext(ConfigureModelContainer())
        context.autosaveEnabled = true
        guard let link: String = pasteboard.string else {
            return .result(
                dialog: "There is no available clipboard text."
            )
        }
        guard let item = await Item(link: link) else {
            return .result(
                dialog: "An error occured. Please try again."
            )
        }
        context.insert(item)
        return .result(dialog: "OK, \(item.metadata?.title ?? item.link ?? "the item") has been added.")
    }
}
