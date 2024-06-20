//
//  DeleteLinkIntent.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/17/24.
//

import Foundation
import AppIntents
import SwiftData
import WidgetKit

struct DeleteLinkIntent: AppIntent {
    static var title: LocalizedStringResource = "Delete Link"
    
    @Parameter(title: "Link")
    var link: LinkEntity?
    
    init(link: Link) {
        self.link = LinkEntity(link: link)
    }
    
    init() {}
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let entities = try await LinkEntityQuery().suggestedEntities()
        guard !entities.isEmpty else {
            return .result(dialog: "There are no links to delete.")
        }
        var enteredLink: LinkEntity
        if let link = link {
            enteredLink = link
        } else {
            enteredLink = try await $link.requestDisambiguation(
                among: LinkEntityQuery().suggestedEntities(),
                dialog: "Which link would you like to delete?"
            )
        }
        let context = ModelContext(ConfigureModelContainer())
        context.autosaveEnabled = true
        let links = try? context.fetch(FetchDescriptor<Link>())
        guard let link = links?.filter({ $0.id == enteredLink.id }).first else {
            return .result(dialog: "An Error Occured")
        }
        context.delete(link)
        try context.save()
        MementoShortcuts.updateAppShortcutParameters()
        WidgetCenter.shared.reloadAllTimelines()
        return .result(dialog: "Okay, \(enteredLink.name ?? enteredLink.link) has been deleted.")
    }
    
    static var parameterSummary: some ParameterSummary {
            Summary("Delete \(\.$link)")
    }
}
