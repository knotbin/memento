//
//  LinkListViewModel.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/24/24.
//

import Foundation

@Observable
class LinkListViewModel {
    var sheetShown = false
    var searchText = ""
    
    func addItemSheet() {
        sheetShown = true
    }
    
    func filterLinks(_ links: [Link]) -> [Link] {
        guard !searchText.isEmpty else {
            return links
        }
        return links.filter {
            if $0.address.localizedCaseInsensitiveContains(searchText) {
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
    
    init() {}
}
