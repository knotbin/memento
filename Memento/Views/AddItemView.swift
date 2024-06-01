//
//  AddItemView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/24/24.
//

import SwiftUI
import SwiftData
import LinkPresentation

struct AddItemView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var viewModel = NewLinkViewModel()
    @Binding var shown: Bool
    
    let provider = LPMetadataProvider()
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Enter URL", text: $viewModel.linkText)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            .navigationTitle("New Item")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        shown = false
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        Task {
                            await addItem(link: viewModel.linkText)
                        }
                        shown = false
                    }
                    .disabled(viewModel.linkText.isEmpty)
                }
            }
        }
    }
    
    func addItem(link: String) async {
        var fulllink = link
        
        if link.hasPrefix("https://www.") || link.hasPrefix("http://www.") || link.hasPrefix("https://") || link.hasPrefix("http://") {
            fulllink = link
        } else if link.hasPrefix("www.") {
            fulllink = "https://\(link)"
        } else {
            fulllink = "https://www.\(link)"
        }
        guard let url = URL(string: fulllink) else {
            return
        }
        
        let metadata = await fetchMetadata(url: url)
        
        let item = Item(link: fulllink, url: url, metadata: CodableLinkMetadata(metadata: metadata))
        modelContext.insert(item)
    }
}

#Preview {
    AddItemView(shown: .constant(false))
        .modelContainer(for: Item.self, inMemory: true)
}
