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
    var searchText = ""
    
    func filterItems(_ items: [Item]) -> [Item] {
        guard !searchText.isEmpty else {
            return items.sorted { (lhs, rhs) in
                if lhs.viewed != rhs.viewed {
                    return !lhs.viewed && rhs.viewed
                }
                return lhs.timestamp > rhs.timestamp
            }
        }
        let filtered = items.filter {
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
        return filtered.sorted { (lhs, rhs) in
            if lhs.viewed != rhs.viewed {
                return !lhs.viewed && rhs.viewed
            }
            return lhs.timestamp > rhs.timestamp
        }
    }
    
    func toggleViewed(_ item: Item) {
        withAnimation {
            item.viewed.toggle()
            UpdateAll()
        }
    }
    func addSheet() {
        sheetShown = true
    }
    
    init() {}
}
