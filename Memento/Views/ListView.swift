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
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            deleteItem(item: item)
                            UpdateAll()
                        }
                        Button(item.viewed ? "Unmark Viewed": "Mark Viewed", systemImage: "book") {
                            item.viewed.toggle()
                            UpdateAll()
                        }
                    }))
                    .swipeActions(edge: .leading) {
                        Button {
                            item.viewed.toggle()
                            UpdateAll()
                        } label: {
                            Label({item.viewed ? "Unmark Viewed" : "Mark Viewed"}(), systemImage: "book")
                        }
                        .tint(.indigo)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            withAnimation {
                                modelContext.delete(item)
                                UpdateAll()
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search Items")
            .overlay {
                if filteredItems.isEmpty {
                    if viewModel.searchText.isEmpty {
                        ContentUnavailableView("No Items Added", systemImage: "item")
                    } else {
                        ContentUnavailableView.search(text: viewModel.searchText)
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Add Item From Clipboard", systemImage: "clipboard") {
                        Task {
                            await addFromPaste()
                        }
                    }
                }
                ToolbarItem {
                    Button(action: viewModel.addSheet) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
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
        guard let address: String = pasteText else {
            return
        }
        guard let item = await makeItem(address: address) else {
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
