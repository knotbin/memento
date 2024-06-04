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
        guard let item = await makeItem(link: link) else {
            return
        }
        modelContext.insert(item)
    }
}

#Preview {
    AddItemView(shown: .constant(false))
        .modelContainer(for: Item.self, inMemory: true)
}
