//
//  ContentView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/21/24.
//

import SwiftUI
import SwiftData
import WidgetKit

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
                WidgetCenter.shared.reloadAllTimelines()
                openURL(url)
            })
            .modelContext(modelContext)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Link.self, inMemory: true)
}
