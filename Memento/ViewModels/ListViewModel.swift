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
    var searchText = ""
    
    func filterItems(_ items: [Item]) -> [Item] {
        guard !searchText.isEmpty else {
            return items
        }
        return items.filter {
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
    }
    func toggleViewed(_ item: Item) {
        withAnimation {
            item.viewed.toggle()
            UpdateAll()
        }
    }
    
    init() {}
}
