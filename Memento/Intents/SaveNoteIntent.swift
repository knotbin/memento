//
//  SaveNoteIntent.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 7/12/24.
//

import Foundation
import AppIntents
import SwiftData

struct SaveNoteIntent: AppIntent {
    static var title: LocalizedStringResource = "Save Note"
    
    @Parameter(title: "Note")
    var note: String?
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let context = ModelContext(ConfigureModelContainer())
        context.autosaveEnabled = true
        var fullnote: String
        if let note = note {
            fullnote = note
        } else {
            fullnote = try await $note.requestValue()
        }
        let item = Item(fullnote)
        context.insert(item)
        try context.save()
        UpdateAll()
        return .result(dialog: "I've added the note to Memento")
        
    }
    static var parameterSummary: some ParameterSummary {
        Summary("Save \(\.$note).")
    }
}
