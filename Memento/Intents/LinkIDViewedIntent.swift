//
//  LinkIDViewedIntent.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/13/24.
//

import Foundation
import AppIntents
import SwiftData

struct LinkIDViewedIntent: AppIntent {
    static var title: LocalizedStringResource = "Toggle Link Viewed from Link ID"
    
    @Parameter(title: "Link ID")
    var linkID: String
    
    init(linkID: String) {
        self.linkID = linkID
    }
    
    init() {
        // empty
    }
    
    let modelContainer = ConfigureModelContainer()
    
    func perform() async throws -> some IntentResult {
        let context = ModelContext(modelContainer)
        let links = try? context.fetch(FetchDescriptor<Link>())
        let filteredLink = links?.filter { $0.id == UUID(uuidString: linkID) }
        if let link = filteredLink?.first {
            link.viewed.toggle()
        }
        try context.save()
        
        return .result()
    }
}
