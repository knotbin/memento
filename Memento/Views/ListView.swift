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
    @Query(sort: \Item.timestamp, order: .reverse, animation: .smooth) private var items: [Item]
    var filteredItems: [Item] {
        viewModel.filterItems(items)
    }
    
    @State var viewModel = ListViewModel()

    var body: some View {
        List(filteredItems) { item in
            ItemView(item: item)
                .contextMenu(
                    ContextMenu(menuItems: {
                        Button(
                            "Delete",
                            systemImage: "trash",
                            role: .destructive,
                            intent: DeleteItemIntent(item: item)
                        )
                        Button(
                            item.viewed ? "Unmark Viewed": "Mark Viewed",
                            systemImage: "book",
                            action: { viewModel.toggleViewed(item) }
                        )
                    })
                )
                .swipeActions(edge: .leading) {
                    Button(
                        { item.viewed ? "Unmark Viewed" : "Mark Viewed" }(),
                        systemImage: "book",
                        action: { viewModel.toggleViewed(item) }
                    ).tint(.indigo)
                }
                .swipeActions(edge: .trailing) {
                    Button(
                        "Delete",
                        systemImage: "trash",
                        role: .destructive,
                        intent: DeleteItemIntent(item: item)
                    )
                }
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
