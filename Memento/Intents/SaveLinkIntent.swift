//
//  SaveLinkIntent.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/15/24.
//

import Foundation
import AppIntents
import SwiftData

struct SaveLinkIntent: AppIntent {
    static var title: LocalizedStringResource = "Save Link"
    
    @Parameter(title: "URL")
    var url: URL?
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let context = ModelContext(ConfigureModelContainer())
        context.autosaveEnabled = true
        var fullurl: URL
        if let url = url {
            fullurl = url
        } else {
            fullurl = try await $url.requestValue()
        }
        print(fullurl.absoluteString)
        guard let link = await makeLink(address: fullurl.absoluteString) else {
            return .result(dialog: "")
        }
        context.insert(link)
        try context.save()
        UpdateAll()
        return .result(dialog: "I've added \(link.metadata?.title ?? link.address) to Memento")
        
    }
}
