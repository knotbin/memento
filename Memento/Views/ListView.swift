//
//  ListView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/24/24.
//

import SwiftUI
import SwiftData

struct ListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.timestamp, order: .reverse, animation: .smooth) private var items: [Item]
    var filteredItems: [Item] {
        viewModel.filterItems(items)
    }
    
    @State var viewModel = ListViewModel()

    var body: some View {
        NavigationStack {
            List(filteredItems) { item in
                ItemView(item: item)
                    .contextMenu(ContextMenu(menuItems: {
                        Button("Delete", systemImage: "trash", role: .destructive, action: {deleteItem(item: item)})
                        Button(item.viewed ? "Unmark Viewed": "Mark Viewed", systemImage: "book") {
                            item.viewed.toggle()
                            UpdateAll()
                        }
                    }))
                    .swipeActions(edge: .leading) {
                        Button({item.viewed ? "Unmark Viewed" : "Mark Viewed"}(), systemImage: "book", action: {viewModel.toggleViewed(item)}).tint(.indigo)
                    }
                    .swipeActions(edge: .trailing) {
                        Button("Delete", systemImage: "trash", role: .destructive, action: {viewModel.toggleViewed(item)})
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
            .toolbar { Button("Add Item", systemImage: "plus", action: viewModel.addSheet) }
            .navigationTitle("Items")
            .sheet(isPresented: $viewModel.sheetShown, content: {
                AddView(shown: $viewModel.sheetShown)
            })
        }
    }
    
    func deleteItem(item: Item) {
        withAnimation {
            modelContext.delete(item)
            UpdateAll()
        }
    }
    
    func addFromPaste() async {
        let pasteText = paste()
        guard let link: String = pasteText else {
            return
        }
        guard let item = await makeItem(link: link) else {
            return
        }
        withAnimation {
            modelContext.insert(item)
            UpdateAll()
        }
    }
}

#Preview {
    ListView()
        .modelContainer(for: Item.self, inMemory: true)
}
