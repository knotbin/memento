//
//  ItemListView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/24/24.
//

import SwiftUI
import SwiftData

struct ItemListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.timestamp, order: .reverse, animation: .smooth) private var items: [Item]
    
    @State var viewModel = LinkListViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                if items.isEmpty {
                    ContentUnavailableView("No Links Added", systemImage: "link")
                } else {
                    Picker(selection: $viewModel.filter, label: Text("Filter")) {
                        ForEach(filters.allCases, id: \.self) { filter in
                            Text(String(describing: filter).capitalized)
                        }
                        
                    }
                    .pickerStyle(.segmented)
                    
                    if !viewModel.checkFilteredData(items: items) {
                        ContentUnavailableView("No Links Added", systemImage: "link")
                    }
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 0) {
                        ForEach(items.filter {
                            viewModel.filterItem(item: $0)
                        }) { item in
                            ItemView(item: item)
                                .contextMenu(ContextMenu(menuItems: {
                                    Button("Delete", systemImage: "trash", role: .destructive) {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                                            deleteItem(item: item)
                                        }
                                    }
                                    Button("Mark Viewed", systemImage: "book") {
                                        item.viewed.toggle()
                                    }
                                }))
                        }
                    }
                }
            }
            .padding()
            
            
            .toolbar {
                ToolbarItem {
                    Button("Add Item From Clipboard", systemImage: "clipboard") {
                        Task {
                            await addFromPaste()
                        }
                    }
                }
                ToolbarItem {
                    Button(action: viewModel.addItemSheet) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Links")
            .sheet(isPresented: $viewModel.sheetShown, content: {
                AddItemView(shown: $viewModel.sheetShown)
            })
        }
    }
    
    func deleteItem(item: Item) {
        withAnimation {
            modelContext.delete(item)
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
        }
    }
}

#Preview {
    ItemListView()
        .modelContainer(for: Item.self, inMemory: true)
}
