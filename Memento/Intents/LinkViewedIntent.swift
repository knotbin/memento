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
    static var title: LocalizedStringResource = "Toggle Link Viewed"
    
    @Parameter(title: "Link")
    var link: LinkEntity
    
    init(link: Link) {
        self.link = LinkEntity(link: link)
    }
    
    init() {}
    
    let modelContainer = ConfigureModelContainer()
    
    func perform() async throws -> some IntentResult {
        let context = ModelContext(modelContainer)
        let links = try? context.fetch(FetchDescriptor<Link>())
        let filteredLink = links?.filter { $0.id == link.id }
        if let link = filteredLink?.first {
            link.viewed.toggle()
        }
        try context.save()
        
        return .result()
    }
    
    static var parameterSummary: some ParameterSummary {
            Summary("Toggle whether \(\.$link) is viewed or not.")
    }
}
