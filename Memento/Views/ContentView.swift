//
//  ContentView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 6/28/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var viewModel = ContentViewModel()
    @Environment(\.modelContext) var modelContext
    @Environment(\.openURL) var openURL
    @Query(animation: .smooth) private var items: [Item]
    var filteredItems: [Item] {
        return viewModel.filterItems(items)
    }
    
    var body: some View {
        NavigationSplitView {
            List(items, selection: $viewModel.selectedItem) { item in
                NavigationLink(value: item) {
                    ItemView(item: item)
                        .modelContext(modelContext)
                }
                .isDetailLink(true)
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
            .toolbar { Button("Add Item", systemImage: "plus", action: viewModel.addSheet) }
            .navigationTitle("Links")
            .sheet(isPresented: $viewModel.sheetShown, content: {
                AddView(shown: $viewModel.sheetShown)
            })
        } detail: {
            if let selectedItem = viewModel.selectedItem {
                DetailView(item: selectedItem, selectedItem: $viewModel.selectedItem)
            } else {
                Text("No Items selected")
            }
        }
        
    }
}

#Preview {
    ContentView()
}
