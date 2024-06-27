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
        LinkListView()
            .onOpenURL(perform: { url in
                let links = try! modelContext.fetch(FetchDescriptor<Link>(predicate: #Predicate { $0.url == url }))
                for link in links {
                    link.viewed = true
                }
                UpdateAll()
                openURL(url)
            })
            .modelContext(modelContext)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Link.self, inMemory: true)
}
