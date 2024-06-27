//
//  AddItemView.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/24/24.
//

import SwiftUI
import SwiftData
import LinkPresentation

struct AddLinkView: View {
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
                    .keyboardType(.URL)
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
                        Task {
                            await addLink(address: viewModel.linkText)
                        }
                        shown = false
                    }
                    .disabled(viewModel.linkText.isEmpty)
                    .keyboardShortcut(.defaultAction)
                    
                }
                
            }
        }
    }
    
    func addLink(address: String) async {
        guard let link = await makeLink(address: address) else {
            return
        }
        modelContext.insert(link)

    }
}

#Preview {
    AddLinkView(shown: .constant(false))
        .modelContainer(for: Link.self, inMemory: true)
}
