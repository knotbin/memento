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
    
    func addItemSheet() {
        sheetShown = true
    }
    
    init() {}
}
