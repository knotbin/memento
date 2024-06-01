//
//  ContentView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/21/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        ItemListView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
