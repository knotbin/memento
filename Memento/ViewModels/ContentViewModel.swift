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
    var infoShown = false
    var searchText = ""
    
    func toggleViewed(_ item: Item) {
        withAnimation {
            item.viewed.toggle()
            UpdateAll()
        }
    }
    
    init() {}
}
