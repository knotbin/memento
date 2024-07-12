//
//  OpenItem.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 7/2/24.
//

import Foundation
import AppIntents
import SwiftData
import SwiftUICore

@available(iOS 18.0, *)
struct OpenItemIntent: AppIntent, OpenIntent, URLRepresentableIntent {
    var value: Never?
    
    static var title: LocalizedStringResource = "Open Item"
    
    
    @Parameter(title: "Item")
    var target: ItemEntity
    
    init(target: Item) {
        self.target = ItemEntity(item: target)
    }
    
    init() {}
    
    static var parameterSummary: some ParameterSummary {
        Summary("Save \(\.$target).")
    }
}
