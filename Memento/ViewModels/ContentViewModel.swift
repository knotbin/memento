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
    var path: [Item] = []
    var sheetShown = false
    var searchText = ""
    
    func filterItems(_ items: [Item]) -> [Item] {
        guard !searchText.isEmpty else {
            return items
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
        let filteredsorted = filtered.sorted { (lhs: Item, rhs: Item) in
            if lhs.viewed == rhs.viewed {
                return lhs.timestamp > rhs.timestamp
            }
            return !lhs.viewed && rhs.viewed
        }
        return filteredsorted
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
