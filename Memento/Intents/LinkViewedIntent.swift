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
    
    let modelContainer = ConfigureModelContainer()
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let entities = try await LinkEntityQuery().suggestedEntities()
        guard !entities.isEmpty else {
            return .result(dialog: "There are no links to mark.")
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
        let context = ModelContext(modelContainer)
        let links = try? context.fetch(FetchDescriptor<Link>())
        let filteredLink = links?.filter { $0.id == enteredLink.id }
        if let link = filteredLink?.first {
            link.viewed = true
        }
        try context.save()
        
        return .result(dialog: "Okay, \(enteredLink.name ?? enteredLink.link) has been marked as viewed.")
    }
    
    static var parameterSummary: some ParameterSummary {
            Summary("Mark \(\.$link) as viewed.")
    }
}
