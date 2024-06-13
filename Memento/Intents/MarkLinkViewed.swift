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
    
    func perform() async throws -> some IntentResult {
        let modelContainer = ConfigureModelContainer()
        let links = try? await modelContainer.mainContext.fetch(FetchDescriptor<Link>())
        let filteredLink = links?.filter { $0.id == link.id }
        if let link = filteredLink?.first {
            link.viewed.toggle()
        }
        
        return .result()
    }
}
