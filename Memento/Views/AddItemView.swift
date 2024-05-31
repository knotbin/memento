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
            .navigationTitle("New Link")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        shown = false
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        addItem(link: viewModel.linkText)
                        shown = false
                    }
                    .disabled(viewModel.linkText.isEmpty)
                }
            }
        }
    }
    
    func addItem(link: String) {
        var fulllink = link
        var mainmetadata = LPLinkMetadata()
        
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
        
        provider.startFetchingMetadata(for: url) { (metadata, error) in
            if let md = metadata {
                DispatchQueue.main.async {
                    mainmetadata = md
                }
            } else {
                return
            }
        }
        
        let item = Item(timestamp: Date(), link: fulllink, url: url, metadata: CodableLinkMetadata(metadata: mainmetadata))
        modelContext.insert(item)
        print(item.metadata.toLPLinkMetadata().title)
    }
}

#Preview {
    AddItemView(shown: .constant(false))
        .modelContainer(for: Item.self, inMemory: true)
}
