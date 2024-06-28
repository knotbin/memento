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
    let modelContext = ModelContext(ConfigureModelContainer())
    var body: some View {
        TabView {
            ListView()
                .tabItem { Label("Items", systemImage: "link") }
            NoteListView()
                .tabItem { Label("Notes", systemImage: "note.text") }
        }
            .modelContext(modelContext)
            .onOpenURL(perform: { url in
                let items = try! modelContext.fetch(FetchDescriptor<Item>(predicate: #Predicate { $0.url == url }))
                for item in items {
                    item.viewed = true
                }
                UpdateAll()
                openURL(url)
            })
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
