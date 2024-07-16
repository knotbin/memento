//
//  ContentViewModel.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/28/24.
//

import Foundation
import SwiftUI

@Observable
class ContentViewModel {
    var selectedItem: Item? = nil
    var sheetShown = false
    var infoShown = false
    var searchText = ""
    
    func filterItems(_ items: [Item]) -> [Item] {
        guard !searchText.isEmpty else {
            return items.sorted { (lhs, rhs) in
//                if lhs.viewed != rhs.viewed {
//                    return !lhs.viewed && rhs.viewed
//                }
                return lhs.timestamp > rhs.timestamp
            }
        }
        let filteredItems = searchText.isEmpty ? items : items.filter { item in
            let searchableFields = [
                item.link?.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "www.", with: ""),
                item.metadata?.title,
                item.note
            ]
            return searchableFields.compactMap { $0 }.contains { $0.localizedCaseInsensitiveContains(searchText) }
        }
        return filteredItems.sorted { (lhs, rhs) in
//            if lhs.viewed != rhs.viewed {
//                return !lhs.viewed && rhs.viewed
//            }
            return lhs.timestamp > rhs.timestamp
        }
    }
    
    func toggleViewed(_ item: Item) {
        withAnimation {
            item.viewed.toggle()
            UpdateAll()
        }
    }
    
    init() {}
}
