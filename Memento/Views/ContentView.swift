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
        LinkListView()
            .onOpenURL(perform: { url in
                openURL(url)
            })
            .modelContext(ModelContext(ConfigureModelContainer()))
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Link.self, inMemory: true)
}
