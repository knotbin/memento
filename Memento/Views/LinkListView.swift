//
//  LinkListView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/24/24.
//

import SwiftUI
import SwiftData

struct LinkListView: View {
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
                    
                    ForEach(items.filter {
                        if viewModel.viewedItems && $0.viewed == true {
                            return true
                        } else if !viewModel.viewedItems && $0.viewed == false {
                            return true
                        } else {
                            return false
                        }
                    }) { item in
                        VStack(alignment: .leading) {
                            URLPreview(url: item.url)
                                .padding(.bottom, 10)
                            HStack {
                                Button {
                                    item.viewed.toggle()
                                } label: {
                                    Image(systemName: "checkmark.circle")
                                }
                                Button(role: .destructive) {
                                    deleteItem(item: item)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .padding()
            
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
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
        modelContext.delete(item)
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
    LinkListView()
        .modelContainer(for: Item.self, inMemory: true)
}
