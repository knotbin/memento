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
    @Query(animation: .smooth) private var items: [Item]
    
    @State var viewModel = LinkListViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                if items.isEmpty {
                    ContentUnavailableView("No Links Added", systemImage: "link")
                } else {
                    Picker(selection: $viewModel.viewedItems, label: Text("")) {
                        Text("Unviewed").tag(false)
                        Text("Viewed").tag(true)
                    }
                    .pickerStyle(.segmented)
                    
                    if !checkFilteredData() {
                        ContentUnavailableView("No Links Added", systemImage: "link")
                    }
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 100) {
                        ForEach(items.filter {
                            if viewModel.viewedItems && $0.viewed == true {
                                return true
                            } else if !viewModel.viewedItems && $0.viewed == false {
                                return true
                            } else {
                                return false
                            }
                        }) { item in
                            ItemView(item: item)
                                .contextMenu(ContextMenu(menuItems: {
                                    Button(role: .destructive) {
                                        deleteItem(item: item)
                                    } label: {
                                        Text("Delete")
                                        Image(systemName: "trash")
                                    }
                                    Button {
                                        item.viewed.toggle()
                                    } label: {
                                        Text("Mark Viewed")
                                        Image(systemName: "book")
                                    }
                                }))
                        }
                    }
                }
            }
            .padding()
            
            
            .toolbar {
                ToolbarItem {
                    Button {
                        Task {
                            await addFromPaste()
                        }
                    } label: {
                        Image(systemName: "clipboard")
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
    
    func checkFilteredData() -> Bool {
        let filteredList = items.filter {
            if viewModel.viewedItems && $0.viewed == true {
                return true
            } else if !viewModel.viewedItems && $0.viewed == false {
                return true
            } else {
                return false
            }
        }
        if filteredList.isEmpty {
            return false
        } else {
            return true
        }
    }
}

#Preview {
    ItemListView()
        .modelContainer(for: Item.self, inMemory: true)
}
