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
            ScrollView {
                ForEach(items) { item in
                    VStack {
                        URLPreview(urlString: item.link)
                        HStack {
                            Button {
                                
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
                .padding()
            }
            
            
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
}

#Preview {
    LinkListView()
        .modelContainer(for: Item.self, inMemory: true)
}
