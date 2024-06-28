//
//  ContentViewModel.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/28/24.
//

import Foundation

@Observable
class ContentViewModel {
    var sheetShown = false
    
    func addSheet() {
        sheetShown = true
    }
    
    init() {}
}
