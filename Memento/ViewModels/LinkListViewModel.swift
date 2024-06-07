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
    
    func filterItem(item: Item) -> Bool {
        if filter == .all {
            return true
        } else if filter == .unviewed && item.viewed == false {
            return true
        } else if filter == .viewed && item.viewed == true {
            return true
        } else {
            return false
        }
    }
    
    func checkFilteredData(items: [Item]) -> Bool {
        let filteredList = items.filter {
            filterItem(item: $0)
        }
        if filteredList.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    init() {}
}
