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
    var viewedItems = false
    var filter: filters = .all
    
    func addItemSheet() {
        sheetShown = true
    }
    
    func filterLink(link: Link) -> Bool {
        if filter == .all {
            return true
        } else if filter == .unviewed && link.viewed == false {
            return true
        } else if filter == .viewed && link.viewed == true {
            return true
        } else {
            return false
        }
    }
    
    func checkFilteredData(links: [Link]) -> Bool {
        let filteredList = links.filter {
            filterLink(link: $0)
        }
        if filteredList.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    init() {}
}
