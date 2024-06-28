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
            if $0.link.localizedCaseInsensitiveContains(searchText) {
                return true
            } else {
                guard let title = $0.metadata?.title else {
                    return false
                }
                if title.localizedCaseInsensitiveContains(searchText) {
                    return true
                } else {
                    return false
                }
            }
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
