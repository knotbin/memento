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
    
//    func perform() async throws -> some OpensIntent {
//        let context = ModelContext(ConfigureModelContainer())
//        context.autosaveEnabled = true
//        
//        let items = try? context.fetch(FetchDescriptor<Item>())
//        guard let item = items?.filter({ $0.id == target.id }).first else {
//            throw dataError()
//        }
//        item.viewed.toggle()
//        try context.save()
//        UpdateAll()
//
//        if #available(iOS 18.0, *) {
//            guard let url = item.url else {
//                return .result()
//            }
//            return .result(opensIntent: OpenURLIntent(url))
//        } else {
//            return .result()
//        }
//    }
    struct urlError: Error {
        let linkUsed: String?
    }
    struct dataError: Error {}
}
