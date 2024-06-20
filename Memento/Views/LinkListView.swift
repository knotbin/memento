//
//  ItemListView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/24/24.
//

import SwiftUI
import SwiftData
import WidgetKit

struct LinkListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Link.timestamp, order: .reverse, animation: .smooth) private var links: [Link]
    
    @State var viewModel = LinkListViewModel()

    var body: some View {
        NavigationStack {
            Picker(selection: $viewModel.filter, label: Text("Filter")) {
                ForEach(filters.allCases, id: \.self) { filter in
                    Text(String(describing: filter).capitalized)
                }
                
            }
            .pickerStyle(.segmented)
            List(links.filter {viewModel.filterLink(link: $0)}) { link in
                CompactLinkView(link: link)
                    .contextMenu(ContextMenu(menuItems: {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6){
                                deleteLink(item: link)
                            }
                        }
                        Button(link.viewed ? "Unmark Viewed": "Mark Viewed", systemImage: "book") {
                            link.viewed.toggle()
                            MementoShortcuts.updateAppShortcutParameters()
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                    }))
            }
            .overlay {
                if links.filter({viewModel.filterLink(link: $0)}).isEmpty {
                    ContentUnavailableView("No Items Found", systemImage: "magnifyingglass")
                }
            }
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
            MementoShortcuts.updateAppShortcutParameters()
            WidgetCenter.shared.reloadAllTimelines()
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
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

#Preview {
    LinkListView()
        .modelContainer(for: Link.self, inMemory: true)
}
