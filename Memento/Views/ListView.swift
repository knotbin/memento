//
//  ListView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 7/17/24.
//

import SwiftUI
import SwiftData

struct ListView: View {
    @State var viewModel = ListViewModel()
    @Binding var selectedItem: Item?
    
    @Environment(\.openURL) var openURL
    @AppStorage("widgetDirectToLink") var widgetDirectToLink: Bool?
    @AppStorage("linkOpenViewed") var linkOpenViewed: Bool?
    
    @Environment(\.modelContext) var modelContext
    @Query(animation: .smooth) private var items: [Item]
    var filteredItems: [Item] {
        return viewModel.filterItems(items)
    }
    
    var body: some View {
        List(filteredItems, selection: $selectedItem) { item in
            NavigationLink(value: item) {
                ItemView(item: item, selectedItem: $selectedItem)
                    .modelContext(modelContext)
            }
            .isDetailLink(true)
            .sensoryFeedback(.selection, trigger: selectedItem)
        }
        .searchable(text: $viewModel.searchText, prompt: "Search Items")
        .overlay {
            if filteredItems.isEmpty {
                if viewModel.searchText.isEmpty {
                    ContentUnavailableView("No Items Added", systemImage: "photo.on.rectangle.angled", description: Text("Add a new item here or through the share sheet in another app. If you have the widget enabled, it will automatically go into rotation."))
                } else {
                    ContentUnavailableView.search(text: viewModel.searchText)
                }
            }
        }
        .onOpenURL(perform: { url in
            if url.absoluteString.hasPrefix("http") {
                guard let matches = try? items.filter(#Predicate { $0.url == url }) else {
                    return
                }
                if linkOpenViewed == Optional(true) || linkOpenViewed == true {
                    for item in matches {
                        item.viewed = true
                    }
                }
                UpdateAll()
                openURL(url)
            } else {
                guard let match = try? items.filter(#Predicate { url.absoluteString.contains($0.id.uuidString) }).first else {
                    return
                }
                if match.link != nil, let url = match.url, (widgetDirectToLink == Optional(true) || widgetDirectToLink == true) {
                    openURL(url)
                } else {
                    selectedItem = match
                }
            }
        })
    }
}

#Preview {
    ListView(selectedItem: .constant(Item("Mama mia")))
}
