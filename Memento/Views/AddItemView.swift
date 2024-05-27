//
//  AddItemView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/24/24.
//

import SwiftUI
import SwiftData

struct AddItemView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var viewModel = NewLinkViewModel()
    @Binding var shown: Bool
    
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
        
        if link.hasPrefix("https://www.") || link.hasPrefix("http://www.") {
            fulllink = link
        } else if link.hasPrefix("www.") {
            fulllink = "https://\(link)"
        } else {
            fulllink = "https://www.\(link)"
        }
        
        let item = Item(timestamp: Date(), link: fulllink)
        modelContext.insert(item)
    }
}

#Preview {
    AddItemView(shown: .constant(false))
        .modelContainer(for: Item.self, inMemory: true)
}
