//
//  ListViewModel.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/24/24.
//

import Foundation
import SwiftUI

@Observable
class ListViewModel {
    var columns: [GridItem] = [GridItem(.adaptive(minimum: 200, maximum: 400)), GridItem(.adaptive(minimum: 200, maximum: 400))]
    var searchText = ""
    var selectingItem = false
    
    func filterItems(_ items: [Item]) -> [Item] {
        guard !searchText.isEmpty else {
            return items.sorted { (lhs, rhs) in
                return lhs.timestamp > rhs.timestamp
            }
        }
        let filteredItems = items.filter {
            if
                let link = $0.link?
                    .replacingOccurrences(of: "https://", with: "")
                    .replacingOccurrences(of: "www.", with: ""),
                link.localizedCaseInsensitiveContains(searchText) {
                return true
            }
            if let title = $0.metadata?.title, title.localizedCaseInsensitiveContains(searchText) {
                return true
            }
            if let note = $0.note, note.localizedCaseInsensitiveContains(searchText) {
                return true
            }
            return false
        }
        return filteredItems.sorted { (lhs, rhs) in
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
