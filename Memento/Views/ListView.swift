//
//  ListView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/24/24.
//

import SwiftUI
import SwiftData

struct ListView: View {
    @Environment(\.openURL) var openURL
    @Environment(\.modelContext) private var modelContext
    @Query(animation: .smooth) private var items: [Item]
    var filteredItems: [Item] {
        let filtered = viewModel.filterItems(items)
        let filteredsorted = filtered.sorted { (lhs: Item, rhs: Item) in
            if lhs.viewed == rhs.viewed {
                return lhs.timestamp > rhs.timestamp
            }
            return !lhs.viewed && rhs.viewed
        }
        return filteredsorted
    }
    
    @State var viewModel = ListViewModel()

    var body: some View {
        List(filteredItems) { item in
            ItemView(item: item)
                .modelContext(modelContext)
        }
        .searchable(text: $viewModel.searchText, prompt: "Search Items")
        .overlay {
            if viewModel.filterItems(items).isEmpty {
                if viewModel.searchText.isEmpty {
                    ContentUnavailableView("No Items Added", systemImage: "doc")
                } else {
                    ContentUnavailableView.search(text: viewModel.searchText)
                }
            }
        }
        .onOpenURL(perform: { url in
            guard let matches = try? items.filter(#Predicate { $0.url == url }) else {
                return
            }
            for item in matches {
                item.viewed = true
            }
            UpdateAll()
            openURL(url)
        })
    }
}

#Preview {
    ListView()
        .modelContainer(for: Item.self, inMemory: true)
}
