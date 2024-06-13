//
//  MarkLinkViewed.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/13/24.
//

import Foundation
import AppIntents
import SwiftData

struct MarkLinkViewed: AppIntent {
    static let title: LocalizedStringResource = "Toggle Link Viewed"
    
    @Parameter(title: "Link")
    var link: LinkEntity
    
    let modelContainer = ConfigureModelContainer()
    
    func perform() async throws -> some IntentResult {
        let context = await modelContainer.mainContext
        let links = try? context.fetch(FetchDescriptor<Link>())
        let filteredLink = links?.filter { $0.id == link.id }
        if let link = filteredLink?.first {
            link.viewed.toggle()
        }
        try context.save()
        
        return .result()
    }
}
