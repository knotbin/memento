//
//  ReloadWidgetIntent.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 8/26/24.
//


import Foundation
import AppIntents
import WidgetKit

struct ReloadWidgetIntent: AppIntent {
    static var title: LocalizedStringResource = "Reload Widget"
    
    func perform() async throws -> some IntentResult {
        print("Reloaded Widget")
        return .result(dialog: "Reloaded Widget")
    }
}
