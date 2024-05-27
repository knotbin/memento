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
                Section {
                    TextField("Enter Name (optional)", text: $viewModel.nameText)
                    TextField("Enter URL", text: $viewModel.linkText)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                Button {
                    addItem(link: viewModel.linkText, name: viewModel.nameText)
                    shown = false
                } label: {
                    Text("Add Link")
                }
            }
            .navigationTitle("New Link")
            .toolbar {
                ToolbarItem {
                    Button {
                        shown = false
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                }
            }
        }
    }
    
    func addItem(link: String, name: String) {
        var url = link
        var title = name
        if link.hasPrefix("https://www.") || link.hasPrefix("http://www.") {
            url = link
        } else if link.hasPrefix("www.") {
            url = "https://\(link)"
        } else {
            url = "https://www.\(link)"
        }
        
        if title == "" {
            title = link
        }
        
        let item = Item(timestamp: Date(), link: url, name: title)
        modelContext.insert(item)
    }
}

#Preview {
    AddItemView(shown: .constant(false))
        .modelContainer(for: Item.self, inMemory: true)
}
