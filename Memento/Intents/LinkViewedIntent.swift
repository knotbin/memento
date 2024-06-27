//
//  LinkViewedIntent.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/13/24.
//

import Foundation
import AppIntents
import SwiftData

struct LinkViewedIntent: AppIntent {
    static var title: LocalizedStringResource = "Mark Link Viewed"
    
    @Parameter(title: "Link")
    var link: LinkEntity?
    
    init(link: Link) {
        self.link = LinkEntity(link: link)
    }
    
    init() {}
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let entities = try await LinkEntityQuery().suggestedEntities().filter({$0.viewed == false})
        guard !entities.isEmpty else {
            return .result(dialog: "There are no unviewed links to mark.")
        }
        var enteredLink: LinkEntity
        if let link = link {
            enteredLink = link
        } else {
            enteredLink = try await $link.requestDisambiguation(
                among: LinkEntityQuery().suggestedEntities(),
                dialog: "Which link would you like to mark viewed?"
            )
        }
        let context = ModelContext(ConfigureModelContainer())
        context.autosaveEnabled = true
        let links = try? context.fetch(FetchDescriptor<Link>())
        guard let link = links?.filter({ $0.id == enteredLink.id }).first else {
            return .result(dialog: "An Error Occured")
        }
        if link.viewed == true {
            return .result(dialog: "Link is already viewed")
        }
        link.viewed = true
        try context.save()
        UpdateAll()
        return .result(dialog: "Okay, \(enteredLink.name ?? enteredLink.link) has been marked as viewed.")
    }
    
    static var parameterSummary: some ParameterSummary {
            Summary("Mark \(\.$link) as viewed.")
    }
}
