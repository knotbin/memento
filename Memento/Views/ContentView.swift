//
//  ContentView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/21/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.openURL) var openURL
    var body: some View {
        ItemListView()
            .onOpenURL(perform: { url in
                openURL(url)
            })
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
