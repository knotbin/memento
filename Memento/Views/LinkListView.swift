//
//  ItemListView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/24/24.
//

import SwiftUI
import SwiftData

struct LinkListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.openURL) var openURL
    @Query(sort: \Link.timestamp, order: .reverse, animation: .smooth) private var links: [Link]
    
    @State var viewModel = LinkListViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                if links.isEmpty {
                    ContentUnavailableView("No Links Added", systemImage: "link")
                } else {
                    Picker(selection: $viewModel.filter, label: Text("Filter")) {
                        ForEach(filters.allCases, id: \.self) { filter in
                            Text(String(describing: filter).capitalized)
                        }
                        
                    }
                    .pickerStyle(.segmented)
                    
                    if !viewModel.checkFilteredData(links: links) {
                        ContentUnavailableView("No Links Added", systemImage: "link")
                    }
                    
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 0) {
                        ForEach(links.filter {
                            viewModel.filterLink(link: $0)
                        }) { item in
                            Button {
                                item.viewed = true
                                openURL(item.url)
                            } label: {
                                LinkView(link: item)
                            }
                                .contextMenu(ContextMenu(menuItems: {
                                    Button("Delete", systemImage: "trash", role: .destructive) {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                                            deleteLink(item: item)
                                        }
                                    }
                                    Button(item.viewed ? "Unmark Viewed": "Mark Viewed", systemImage: "book") {
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
                    Button("Add Link From Clipboard", systemImage: "clipboard") {
                        Task {
                            await addFromPaste()
                        }
                    }
                }
                ToolbarItem {
                    Button(action: viewModel.addItemSheet) {
                        Label("Add Link", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("Links")
            .sheet(isPresented: $viewModel.sheetShown, content: {
                AddLinkView(shown: $viewModel.sheetShown)
            })
        }
    }
    
    func deleteLink(item: Link) {
        withAnimation {
            modelContext.delete(item)
        }
    }
    
    func addFromPaste() async {
        let pasteText = paste()
        guard let address: String = pasteText else {
            return
        }
        guard let link = await makeLink(address: address) else {
            return
        }
        withAnimation {
            modelContext.insert(link)
            MementoShortcuts.updateAppShortcutParameters()
        }
    }
}

#Preview {
    LinkListView()
        .modelContainer(for: Link.self, inMemory: true)
}
