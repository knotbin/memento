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
    var filteredLinks: [Link] {
        guard !viewModel.searchText.isEmpty else {
            return links
        }
        return links.filter {
            if $0.address.localizedCaseInsensitiveContains(viewModel.searchText) {
                return true
            } else {
                guard let title = $0.metadata?.title else {
                    return false
                }
                if title.localizedCaseInsensitiveContains(viewModel.searchText) {
                    return true
                } else {
                    return false
                }
            }
        }
    }
    
    @State var viewModel = LinkListViewModel()

    var body: some View {
        NavigationStack {
            List(filteredLinks) { link in
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
            .searchable(text: $viewModel.searchText, prompt: "Search Links")
            .overlay {
                if filteredLinks.isEmpty {
                    ContentUnavailableView.search(text: viewModel.searchText)
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
