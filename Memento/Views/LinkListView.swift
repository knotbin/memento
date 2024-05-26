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
    @Query private var items: [Item]
    
    @State var viewModel = LinkListViewModel()

    var body: some View {
        NavigationStack {
            if items.isEmpty {
                ContentUnavailableView("No Links Added", systemImage: "link")
            }
            List {
                ForEach(items) { item in
                    Link(item.link, destination: URL(string: item.link)!)
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItemSheet) {
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

    private func addItemSheet() {
        viewModel.sheetShown = true
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    LinkListView()
        .modelContainer(for: Item.self, inMemory: true)
}
